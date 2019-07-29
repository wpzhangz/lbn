clc
% Main function for K2 algorithm, all other functions and display the results

% The network we choose is Child network and the sample size is 100
fprintf('The network we choose is Child network and the sample size  is 100 \n\n')

filename = sprintf('Child_s100.csv');
data=load(filename);

N=size(data,2);
% ns = 3*ones(1,N); 
ns = max(data);
max_fan_in = 4;    % Maximum number of parent nodes

%-----real BN------
load Child_graph.txt
true_b=Child_graph;

order=topological_sort(true_b);  % Õÿ∆À≈≈–Ú
data=data';
dag2 = learn_struct_K2(data, ns,order, 'max_fan_in', max_fan_in);

TLE=sum(sum(((dag2-true_b)~=0)));
TP=sum(sum(true_b))-sum(sum(((true_b-dag2)==1)));
FP=sum(sum(((true_b-dag2)==-1)));

fprintf('FP= \n %d \n\n', FP)
fprintf('TP= \n %d \n ', TP)




