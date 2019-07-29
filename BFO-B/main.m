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


s = 100;   % 细菌的个数
Nc = 30;  % 趋化的次数
Ns = 4;   % 趋化操作中单向运动的最大步数
Nre = 4;    % 复制操作步骤数
Ned = 3;    % 驱散(迁移)操作数
Sr = s/2;   % 每代复制（分裂）数
Ped = 0.1; % 细菌驱散(迁移)概率

% 分配内存可以提高运行速度
K2=zeros(Dim,s,Nc);
% K2S=zeros(s,Nc);
dag=zeros(Dim,Dim,s,Nc);

rand('seed',8);
for i = 1:s     % 产生初始细菌个体的位置
    dag(1:Dim,1:Dim,i,1)=mk_rnd_dag(Dim,2);
    K2(:,i,1) = K2Score( LG,dag(1:Dim,1:Dim,i,1));
end
%------------------细菌趋药性算法循环开始---------------------
%-----(2)驱散(迁移)操作开始-----
for l = 1:Ned
    l;
    %-----(3)复制操作开始-----
    for k = 1:Nre
        k;
        %-----(4)趋化操作(翻转或游动)开始-----
        for j = 1:Nc
            %-----(4.1)对每一个细菌分别进行以下操作-----
            for i = 1:s
                %-----(4.2)计算函数J(i,j,k,l)，表示第i个细菌在第l次驱散第k次复制第j次趋化时的适应度值-----
                if j>1          %避免重复调用
                    K2(:,i,j)=K2(:,i,j-1);
                    dag(1:Dim,1:Dim,i,j)=dag(1:Dim,1:Dim,i,j-1);
                end
                
                %-----(4.4)保存细菌目前的适应度值，直到找到更好的适应度值取代之-----
                %                 daglast=dag(1:Dim,1:Dim,i,j,k,l);
                K2last = K2(:,i,j);
                daglast=dag(1:Dim,1:Dim,i,j);
%                 sum(K2last)
%                 test=K2Score( LG,daglast);
%                 sum(test)
                
                %-----(4.5)翻转，分别尝试四个移动方向，并选出评分增加最多的方向
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
                %-----(4.8)游动-----
                m = 0; % 给游动长度计数器赋初始值
                while(m < Ns) % 未达到游动的最大长度，则循环
                    m = m + 1;
                    if (sum(K2temp) > sum(K2last))
                        daglast=dagtemp;
                        K2last = K2temp;  %保存更好的适应度值
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
                        % 否则，结束此次游动
                        m = Ns;
                    end
                end
                dag(1:Dim,1:Dim,i,j)=daglast;
                K2(:,i,j) = K2last; 
            end  % 如果i<N，进入下一个细菌的趋化，i=i+1
            %-----(5)如果j<Nc，此时细菌还处于活跃状态，进行下一次趋化，j=j+1----
            %         K2last
        end
        %----------------下面进行复制操作----------------
        %-----(6)复制-----
        %-----(6.1)根据所给的k和l的值，将每个细菌的适应度值按升序排序-----
        Jhealth = sum(sum(K2,1),3);  % 给每个细菌设置健康函数值
        [Jhealth,sortind] = sort(Jhealth); % 按健康函数值升序排列函数
        dag(1:Dim,1:Dim,:,1) = dag(1:Dim,1:Dim,sortind,Nc);     
        K2(:,:,1)=K2(:,sortind,Nc);
        %         C(:,k+1) = C(sortind,k);
        %-----(6.2)将代价小的一半细菌分裂成两个，代价大的一半细菌死亡-----
        for i = 1:Sr
            % 健康值较差的Sr个细菌死去，Sr个细菌分裂成两个子细菌，保持个体总数的s一致性
            dag(1:Dim,1:Dim,i,1) = dag(1:Dim,1:Dim,i+Sr,1);
            K2(:,i,1)=K2(:,i+Sr,1);
            %             C(i+Sr,k+1) = C(i,k+1);
        end
        %-----(7)如果k<Nre，转到(3)，进行下一代细菌的趋化-----
    end
    %-----(8)趋散，对于每个细菌都以Ped的概率进行驱散，但是驱散的细菌群体的总数
    %--------保持不变，一个细菌被驱散后，将被随机重新放置到一个新的位置
    for m = 1:s
        if(Ped > rand)
            dag(1:Dim,1:Dim,m,1) = mk_rnd_dag(Dim,2);
            K2(:,m,1) = K2Score( LG,dag(1:Dim,1:Dim,m,1));
        end
        %         else
        %             dag(1:Dim,1:Dim,m,1) = dag(1:Dim,1:Dim,m,Nc);  % 未驱散的细菌
    end
    
end  % 如果l<Ned，转到(2)，否则结束

%-------------------------报告----------------------

reproduction =sum( K2(:,:,Nc),1);
[K2lastreproduction,best] = max(reproduction);
dagbest = dag(1:Dim,1:Dim,best,j);
sum(sum(dagbest));

TLE=sum(sum(((dagbest-true_b)~=0)));
TP=sum(sum(true_b))-sum(sum(((true_b-dagbest)==1)));
FP=sum(sum(((true_b-dagbest)==-1)));

fprintf('FP= \n %d \n\n', FP)
fprintf('TP= \n %d \n ', TP)


