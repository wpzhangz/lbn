clc

% DAG = [0,1,0,1,0;
%     0,0,1,0,1;
%     0,0,0,0,0;
%     0,0,0,0,0;
%     0,0,0,0,0];
DAG=mk_rnd_dag(5);
% shang=triu(DAG,0);
% DAG=DAG-shang;
a=sum(sum(DAG));
ID = {};

for i = 1:size(DAG,1)
    temp = sprintf('X%d',i);                       %½Úµã±àºÅ
    temp = num2str(temp);
    ID{i} = temp;
end

% gobj=biograph(coe(:,1:end-1)',ID,'LayoutScale',1,'NodeAutoSize','on','ShowArrows','oN','ShowWeights','on','LayoutType','equilibrium');

gobj=biograph(DAG,ID,'ShowArrows','oN','ShowWeights','off','LayoutType','radial');
set(gobj.nodes,'Size',[8,8],'FontSize',10,'Shape','circle');
% set(gobj.nodes,'Size',[8,8],'FontSize',10);
view(gobj);




