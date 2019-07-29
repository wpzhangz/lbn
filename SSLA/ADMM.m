function [z, history] = ADMM(data, lab, lambda, p, bal_lambda, theta,ada)
% ADMM algorithm

data_old=data;
%t_start = tic;
[m, n] = size(data); %n=20
QUIET    = 0;
MAX_ITER = 500;
ABSTOL   = 1e-4;
RELTOL   = 1e-2;

inputSize = sum(max(data))+1;
numClasses = max(lab);     % Number of classes 

%length(find(data<=0))
rho =10; 
data=dummyvar(data);  %new_data  100*60
inputData=data' ;  %60*100
inputData=[inputData;ones(1,m)];

theta = theta(:);
size(theta);
z = zeros(numClasses * inputSize, 1);
u = zeros(numClasses * inputSize, 1);

for k = 1:MAX_ITER
       
% theta-update
    
%[cost, grad] = softmaxCost(theta, numClasses, inputSize, rho, inputData, lab,z,u);
theta_old = theta;   
options.maxIter = 100;
softmaxModel = softmaxTrain(inputSize, numClasses, rho, ...
                            inputData, lab, options,z,u,theta_old);
theta=softmaxModel.optTheta;
    
  
% z-update 
zold=z;
z=shrinkage(theta+u,(lambda*ada+bal_lambda*p)/rho,data_old,numClasses);
z=z';
    
%u-update
    u = u + theta - z;

    % diagnostics, reporting, termination checks
   % history.objval(k)  = objective(A, b, mu, x, z);

    history.r_norm(k)  = norm(theta - z);
    history.s_norm(k)  = norm(rho*(z - zold));

    n=size(data,1);

    history.eps_pri(k) = sqrt(n)*ABSTOL + RELTOL*max(norm(theta), norm(z));
    history.eps_dual(k)= sqrt(n)*ABSTOL + RELTOL*norm(rho*u);

  %  if ~QUIET
  %      fprintf('%3d\t%10.4f\t%10.4f\t%10.4f\t%10.4f\t%10.2f\n', k, ...
  %          history.r_norm(k), history.eps_pri(k), ...
   %         history.s_norm(k), history.eps_dual(k), history.objval(k));
  %  end


    if history.r_norm(k) < history.eps_pri(k) && ...
       history.s_norm(k) < history.eps_dual(k)
        break;
    end
end

if ~QUIET
    %toc(t_start);
end

function z = shrinkage(a, kappa,data,c)
d=max(data);

for i=1:size(data,2)
    b=sum(d(1:i));
    
z((b-d(i))*c+1:b*c) = max(0, (1-kappa(i)/norm(a((b-d(i))*c+1:b*c),2)))*a((b-d(i))*c+1:b*c);
z(b*c+1:b*c+c)=a(b*c+1:b*c+c);
end
  