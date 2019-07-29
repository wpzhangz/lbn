function b_coe = discrete_BN0(b_coe,X)
% discrete_BN0 compute unpenalized maximum likelihood estimator

max_iter = 1;
A = max(X);
[~, p] = size(X);   % m=100,n=21

diff = 1000;
iter = 0;
precision = 1e-6;
rho=0;
z=0;
u=0;

while iter < max_iter &&(norm(diff,'fro') >= precision)         
    %fprintf('\n \n \n ======================= Globally the %d iteration========================= \n \n \n ',iter);
    iter = iter+1;
    b_coe_p = b_coe;

    for j = 1:p
        a=sum(A(1:j));
        bp=b_coe((a-A(j)+1):a,[1:a-A(j),a+1:end]);
        
        lab = X(:,j);
        data = X(:,[1:j-1,j+1:end]);
   %     data_old=data;
        [m, n] = size(data); 
        inputSize = sum(max(data))+1;
        numClasses = max(lab);     % Number of classes 
        data=dummyvar(data);  %new_data  100*60
        inputData=data' ;  %60*100
        inputData=[inputData;ones(1,m)];
        
        bp = bp(:);

       
       options.maxIter = 500;
       softmaxModel = softmaxTrain(inputSize, numClasses, rho, ...
                            inputData, lab, options,z,u,bp);
       theta=softmaxModel.optTheta;
        
        b_coe((a-A(j)+1):a,[1:a-A(j),a+1:end]) = reshape(theta,A(j), sum(A)-A(j)+1);
        
    end
    iter;
    diff = b_coe - b_coe_p;
    nonzero = sum(sum(b_coe~=0));
   % fprintf('\n \n  Globally the current diff is %d ; num of nonzero is %d \n \n \n', norm(diff,'fro'), nonzero);
end
