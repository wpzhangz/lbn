function  [K2up,incre,dag1] = add( LG,dag ,K2Score)

%增加一条边后的得分和图
%Input: 数据集和网络结构(用邻接矩阵表示)
%Output: K2得分变化值和新的网络

K2up=K2Score;
dag1=dag;
Dim = LG.VarNumber;
incre=-Inf;

a=find(dag==0);  %返回为0元素的位置
L=length(a);
for i=1:L
    rand = randsrc(1,1,[1:length(a)]);
    row = mod(a(rand),Dim);
    if row==0
        row=Dim;
    end
    column = ceil(a(rand)/Dim);
    dag1(row,column)=1;
    par_new=find(dag1(:,column)==1);
%     if length(par_new) > 2 ,break;end
 
    if acyclic(dag1)
        K2up(column)=localscore(LG,column,par_new);
        incre=K2up(column)-K2Score(column);
        break;
    else
        a(rand)=[];
        dag1=dag;
    end
end

end


