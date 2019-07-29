clc
% Main function for SSLA algorithm given the true order of nodes

% The network we choose is Child and the sample size is 100
fprintf('The network we choose is the Child network, and the sample size  is 100 \n\n')
fprintf('about two minutes ... \n\n')

filename = [sprintf('Child_s100.csv')];   % read data
data=load(filename);

nu=max(data);
n=sum(nu);
load Child_graph.txt   % read the true network
true_b=Child_graph;
order=topological_sort(true_b);

sum(sum(true_b));    % number of edges

[m, p] = size(data);
prior_bcoe = zeros(n,n+1);

for j = 1:p
    a=sum(nu(1:j));
    rand('state',0);
    prior_bcoe(a-nu(j)+1:a,[1:a-nu(j),a+1:end-1]) = rand(nu(j),n-nu(j))*10;  %产生初始系数3n*3n
end

lambda1=nan;

for lambda=0.21

bal_lambda=1000000;

omega=ones(p);
gamma=0.2;

% compute unpenalized maximum likelihood estimator
b_coe2=discrete_BN0(prior_bcoe,data);
b_coe=trans(b_coe2,nu);
omega=1./b_coe.^gamma;

b_coe1=discrete_BN(b_coe2,data,lambda,bal_lambda,omega);
b=trans(b_coe1,nu);
b = [b~=0];
b=b';

for i=1:p
    j=order(i);
    par_can=order(1:i-1);
    par_i=find(b(:,j)==1);
    del = setdiff(par_i,par_can);
    b(del,j)=0;
end

TLE=sum(sum(((b-true_b)~=0)));
TP=sum(sum(true_b))-sum(sum(((true_b-b)==1)));
FP=sum(sum(((true_b-b)==-1)));

fprintf('FP= \n %d \n\n', FP)
fprintf('TP= \n %d \n ', TP)
end




