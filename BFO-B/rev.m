function  [K2up,incre,dag3] = rev( LG,dag ,K2Score)

%����һ���ߺ�ĵ÷ֺ�ͼ
%Input: ���ݼ�������ṹ(���ڽӾ����ʾ)
%Output: K2�÷ֱ仯ֵ���µ�����
dag3=dag;
Dim = LG.VarNumber;
incre=-Inf;
K2up=K2Score;

a=find(dag3) ; %���ز�Ϊ0Ԫ�ص�λ��
L=length(a);

if isempty(a)
    incre=-Inf;
else
    for i=1:L
        rand = randsrc(1,1,[1:length(a)]);
        row = mod(a(rand),Dim);
        if row==0
            row=Dim;
        end
        column = ceil(a(rand)/Dim);
        dag3(row,column)=0;
        dag3(column,row)=1;
        par_new_i=find(dag3(:,column)==1);
        par_new_j=find(dag3(:,row)==1);
%         if length(par_new_j) > 2,break;end
        
        if acyclic(dag3) 
            K2up(column)=localscore(LG,column,par_new_i);
            incre_i=K2up(column)-K2Score(column);
            K2up(row)=localscore(LG,row,par_new_j);
            incre_j=K2up(row)-K2Score(row);
            incre=incre_i+ incre_j;
            break;
        else
            a(rand)=[];
            dag3=dag;
        end
    end
end
end

