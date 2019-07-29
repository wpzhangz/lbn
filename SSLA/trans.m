function dag=trans(b_coe,nu)
% Obtaining the adjacency matrix of Bayesian network based on parameters

%c=zeros(3,3);
n=size(nu,2);
dag=zeros(n,n);
for i=1:n
    for j=1:n
        a=sum(nu(1:i));
        b=sum(nu(1:j));
        c=b_coe(a-nu(i)+1:a,b-nu(j)+1:b);
        dag(i,j)=norm(c,'fro');
    end
end
