function  [K2up,incre,dag2] = del( LG,dag,K2Score )

%ɾ��һ���ߺ�ĵ÷ֺ�ͼ
%Input: ���ݼ�������ṹ(���ڽӾ����ʾ)
%Output: K2�÷ֱ仯ֵ���µ�����
dag2=dag;
Dim = LG.VarNumber;
K2up=K2Score;

a=find(dag2);  %���ز�Ϊ0Ԫ�ص�λ��
if isempty(a)
    incre=-Inf;
else
    rand = randsrc(1,1,[1:length(a)]);
    row = mod(a(rand),Dim);
    if row==0
        row=Dim;
    end
    column = ceil(a(rand)/Dim);
    dag2(row,column)=0;
%     par_old=find(dag(:,column)==1);
    par_new=find(dag2(:,column)==1);
    K2up(column)=localscore(LG,column,par_new);
    incre=K2up(column)-K2Score(column);
end
end



