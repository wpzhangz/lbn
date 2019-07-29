%*********************BFO-B algorithm**********************
clear;
clc;

% The network we choose is Child network, and the sample size  is 100
fprintf('The network we choose is Child network, and the sample size  is 100 \n\n')
fprintf('about three minutes ... \n\n')

% -----data set------
filename = sprintf('Child_s100.csv');
data=load(filename);
LGObj = ConstructLGObj(data);   % construct an object
LG = struct( LGObj );
Dim = LG.VarNumber;

%-----true network------
load Child_graph.txt   
true_b=Child_graph;
% true_b=textread('HailFinder10_graph.txt');
sum(sum(true_b));
%-----(1)initializing-----


s = 100;   % ϸ���ĸ���
Nc = 30;  % �����Ĵ���
Ns = 4;   % ���������е����˶��������
Nre = 4;    % ���Ʋ���������
Ned = 3;    % ��ɢ(Ǩ��)������
Sr = s/2;   % ÿ�����ƣ����ѣ���
Ped = 0.1; % ϸ����ɢ(Ǩ��)����

% �����ڴ������������ٶ�
K2=zeros(Dim,s,Nc);
% K2S=zeros(s,Nc);
dag=zeros(Dim,Dim,s,Nc);

rand('seed',8);
for i = 1:s     % ������ʼϸ�������λ��
    dag(1:Dim,1:Dim,i,1)=mk_rnd_dag(Dim,2);
    K2(:,i,1) = K2Score( LG,dag(1:Dim,1:Dim,i,1));
end
%------------------ϸ����ҩ���㷨ѭ����ʼ---------------------
%-----(2)��ɢ(Ǩ��)������ʼ-----
for l = 1:Ned
    l;
    %-----(3)���Ʋ�����ʼ-----
    for k = 1:Nre
        k;
        %-----(4)��������(��ת���ζ�)��ʼ-----
        for j = 1:Nc
            %-----(4.1)��ÿһ��ϸ���ֱ�������²���-----
            for i = 1:s
                %-----(4.2)���㺯��J(i,j,k,l)����ʾ��i��ϸ���ڵ�l����ɢ��k�θ��Ƶ�j������ʱ����Ӧ��ֵ-----
                if j>1          %�����ظ�����
                    K2(:,i,j)=K2(:,i,j-1);
                    dag(1:Dim,1:Dim,i,j)=dag(1:Dim,1:Dim,i,j-1);
                end
                
                %-----(4.4)����ϸ��Ŀǰ����Ӧ��ֵ��ֱ���ҵ����õ���Ӧ��ֵȡ��֮-----
                %                 daglast=dag(1:Dim,1:Dim,i,j,k,l);
                K2last = K2(:,i,j);
                daglast=dag(1:Dim,1:Dim,i,j);
%                 sum(K2last)
%                 test=K2Score( LG,daglast);
%                 sum(test)
                
                %-----(4.5)��ת���ֱ����ĸ��ƶ����򣬲�ѡ�������������ķ���
                [K2_1,incre1,dag1] = add( LG,daglast, K2last);
                [K2_2,incre2,dag2] = del( LG,daglast, K2last );
                [K2_3,incre3,dag3] = rev( LG,daglast, K2last );
                [K2_4,incre4,dag4] = mov( LG,daglast, K2last );
                
                [newincre,mark]=sort([incre1,incre2,incre3,incre4]);
                DAG{1}=dag1;DAG{2}=dag2;DAG{3}=dag3;DAG{4}=dag4;
                KK2{1}=K2_1;KK2{2}=K2_2;KK2{3}=K2_3;KK2{4}=K2_4;
                dagtemp=DAG{mark(4)};
                K2temp=KK2{mark(4)};
                incremax = newincre(4);
                %-----(4.8)�ζ�-----
                m = 0; % ���ζ����ȼ���������ʼֵ
                while(m < Ns) % δ�ﵽ�ζ�����󳤶ȣ���ѭ��
                    m = m + 1;
                    if (sum(K2temp) > sum(K2last))
                        daglast=dagtemp;
                        K2last = K2temp;  %������õ���Ӧ��ֵ
                        switch mark(4)
                            case{1}
                                [K2temp,incre,dagtemp] = add( LG,daglast,K2last );
                            case{2}
                                [K2temp,incre,dagtemp] = del( LG,daglast, K2last);
                            case{3}
                                [K2temp,incre,dagtemp] = rev( LG,daglast ,K2last);
                            otherwise
                                [K2temp,incre,dagtemp] = mov( LG,daglast ,K2last);
                        end
                    else
                        % ���򣬽����˴��ζ�
                        m = Ns;
                    end
                end
                dag(1:Dim,1:Dim,i,j)=daglast;
                K2(:,i,j) = K2last; 
            end  % ���i<N��������һ��ϸ����������i=i+1
            %-----(5)���j<Nc����ʱϸ�������ڻ�Ծ״̬��������һ��������j=j+1----
            %         K2last
        end
        %----------------������и��Ʋ���----------------
        %-----(6)����-----
        %-----(6.1)����������k��l��ֵ����ÿ��ϸ������Ӧ��ֵ����������-----
        Jhealth = sum(sum(K2,1),3);  % ��ÿ��ϸ�����ý�������ֵ
        [Jhealth,sortind] = sort(Jhealth); % ����������ֵ�������к���
        dag(1:Dim,1:Dim,:,1) = dag(1:Dim,1:Dim,sortind,Nc);     
        K2(:,:,1)=K2(:,sortind,Nc);
        %         C(:,k+1) = C(sortind,k);
        %-----(6.2)������С��һ��ϸ�����ѳ����������۴��һ��ϸ������-----
        for i = 1:Sr
            % ����ֵ�ϲ��Sr��ϸ����ȥ��Sr��ϸ�����ѳ�������ϸ�������ָ���������sһ����
            dag(1:Dim,1:Dim,i,1) = dag(1:Dim,1:Dim,i+Sr,1);
            K2(:,i,1)=K2(:,i+Sr,1);
            %             C(i+Sr,k+1) = C(i,k+1);
        end
        %-----(7)���k<Nre��ת��(3)��������һ��ϸ��������-----
    end
    %-----(8)��ɢ������ÿ��ϸ������Ped�ĸ��ʽ�����ɢ��������ɢ��ϸ��Ⱥ�������
    %--------���ֲ��䣬һ��ϸ������ɢ�󣬽���������·��õ�һ���µ�λ��
    for m = 1:s
        if(Ped > rand)
            dag(1:Dim,1:Dim,m,1) = mk_rnd_dag(Dim,2);
            K2(:,m,1) = K2Score( LG,dag(1:Dim,1:Dim,m,1));
        end
        %         else
        %             dag(1:Dim,1:Dim,m,1) = dag(1:Dim,1:Dim,m,Nc);  % δ��ɢ��ϸ��
    end
    
end  % ���l<Ned��ת��(2)���������

%-------------------------����----------------------

reproduction =sum( K2(:,:,Nc),1);
[K2lastreproduction,best] = max(reproduction);
dagbest = dag(1:Dim,1:Dim,best,j);
sum(sum(dagbest));

TLE=sum(sum(((dagbest-true_b)~=0)));
TP=sum(sum(true_b))-sum(sum(((true_b-dagbest)==1)));
FP=sum(sum(((true_b-dagbest)==-1)));

fprintf('FP= \n %d \n\n', FP)
fprintf('TP= \n %d \n ', TP)


