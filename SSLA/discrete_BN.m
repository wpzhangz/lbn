function b_coe = discrete_BN(b_coe,X,lambda,bal_lambda,omega)
% Calculate parameters using block coordinate descent algorithm and ADMM algorithm

% b_coe: The parameters of the BN. E.g., b_coe(i,j) = 0.5 represents that
% variable j is a parent of variable i, while the regression effect is 0.5.

max_iter = 5;
A = max(X);
[m, p] = size(X);   % m=100,n=21

diff = 1000;
iter = 0;
precision = 1e-6;

while iter <= max_iter &&(norm(diff,'fro') >= precision)         
    %fprintf('\n \n \n ======================= Globally the %d iteration========================= \n \n \n ',iter);
    iter = iter+1;
    b_coe_p = b_coe;

    for j = 1:p
        %b_coe = b_coe.*([abs(b_coe)>0.01]);
        dag=trans(b_coe,A);    %通过系数得到图,不一定是DAG
        %dag = [dag>0.001];   
        %dag = (dag+dag)/2;      
        DG = mk_dag_dg(dag);
        [dist,path,pred] = graphshortestpath(DG,j,'METHOD','BFS');
        dist = dist([1:j-1,j+1:end]);
        index = union(find(dist~=inf),find(dist==0));
        path_coe = zeros(p-1,1);
        path_coe(index) = ones(length(index),1);
       % path_coe = path_coe + dag([1:j-1,j+1:end],j);
        a=sum(A(1:j));
        bp=b_coe((a-A(j)+1):a,[1:a-A(j),a+1:end]);
        size(bp);
        ada = omega(j,[1:j-1,j+1:end]);
        [theta,history] = ADMM(X(:,[1:j-1,j+1:end]), X(:,j), lambda, path_coe,...
                                   bal_lambda, bp,ada);
        
        b_coe((a-A(j)+1):a,[1:a-A(j),a+1:end]) = reshape(theta,A(j), sum(A)-A(j)+1);
        
    end
    iter;
    diff = b_coe - b_coe_p;
    nonzero = sum(sum(b_coe~=0));
    %fprintf('\n \n  Globally the current diff is %d ; num of nonzero is %d \n \n \n', norm(diff,'fro'), nonzero);
end




function DG = mk_dag_dg(dag)

p = size(dag,1);
[b,a] = find(dag~=0);
DG = sparse(a,b,ones(1,size(a,1)),p,p);