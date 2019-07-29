function  [K2up,incre,dag1] = add( LG,dag ,K2Score)

%����һ���ߺ�ĵ÷ֺ�ͼ
%Input: ���ݼ�������ṹ(���ڽӾ����ʾ)
%Output: K2�÷ֱ仯ֵ���µ�����

K2up=K2Score;
dag1=dag;
Dim = LG.VarNumber;
incre=-Inf;

a=find(dag==0);  %����Ϊ0Ԫ�ص�λ��
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


