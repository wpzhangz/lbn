function  [K2up,incre,dag4] = mov( LG,dag,K2Score )

%�ƶ������ߺ�ĵ÷ֺ�ͼ
%Input: ���ݼ�������ṹ(���ڽӾ����ʾ)
%Output: K2�÷ֱ仯ֵ���µ�����
dag4=dag;
Dim = LG.VarNumber;
K2up=K2Score;

% �ҵ����ڵ㼯�ϲ�Ϊ�յĽڵ�
A=find(sum(dag,1)~=0);
incre=-Inf;
for m=1:10000
    if length(A)<=1,break;end
    
    var=A(randperm(length(A),2));  %���ѡȡ�������ظ��ı���
    par_i=find(dag(:,var(1))==1);
    par_j=find(dag(:,var(2))==1);
    
    if (isequal(par_i,par_j) && length(par_i)==1) || all(ismember(par_i,par_j)) || all(ismember(par_j,par_i))
        continue;
    else
        while 1
            k=par_i(randperm(length(par_i),1));
            l=par_j(randperm(length(par_j),1));
            if k~=l ,break;end
        end
        dag4(k,var(1))=0;
        dag4(k,var(2))=1;
        dag4(l,var(1))=1;
        dag4(l,var(2))=0;
        par_new_i=find(dag4(:,var(1))==1);
        par_new_j=find(dag4(:,var(2))==1);
        
        if acyclic(dag4)
            K2up(var(1))=localscore(LG,var(1),par_new_i);
            incre_i=K2up(var(1))-K2Score(var(1));
            K2up(var(2))=localscore(LG,var(2),par_new_j);
            incre_j=K2up(var(2))-K2Score(var(2));
            incre=incre_i+ incre_j;
            break
        else
            dag4=dag;
        end
    end
end


end
