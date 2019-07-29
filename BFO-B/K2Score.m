function  K2Score = K2Score( LG,dag )
%Input: ���ݼ�������ṹ(���ڽӾ����ʾ)
%Output: K2�÷�

Dim = LG.VarNumber;
acyclic(dag);
K2Score=zeros(Dim,1);


%-------Ϊ��ʹ�õ���ͼ��Ϊ��ͼ--------

for i = 1:Dim
    par_i=find(dag(:,i)==1);
    LocalScore = localscore( LG, i, par_i );
    K2Score(i)=LocalScore;
end

end
