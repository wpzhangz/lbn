function  K2Score = K2Score( LG,dag )
%Input: 数据集和网络结构(用邻接矩阵表示)
%Output: K2得分

Dim = LG.VarNumber;
acyclic(dag);
K2Score=zeros(Dim,1);


%-------为了使得到的图不为空图--------

for i = 1:Dim
    par_i=find(dag(:,i)==1);
    LocalScore = localscore( LG, i, par_i );
    K2Score(i)=LocalScore;
end

end
