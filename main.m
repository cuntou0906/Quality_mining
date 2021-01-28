clear;clc;                                      %清除数据和记录
moviedata = importdata('movielens.txt');        %读入文件
usermin = min(moviedata(:,1));                  %用户最小id
usermax = max(moviedata(:,1));                  %用户最大的id
promin = min(moviedata(:,2));                   %电影最小的id
promax = max(moviedata(:,2));                   %电影最大的id
userlen = usermax-usermin+1;                    %用户数目
prolen = promax-promin+1;                       %电影数目
links = zeros(usermax-usermin+1,promax-promin+1);%初始化用户评分电脑对应矩阵
for i = 1:size(moviedata,1)                     %利用数据计算评分矩阵
    links(moviedata(i,1),moviedata(i,2)) = moviedata(i,3);
end
repu = ones(userlen,1);                         %用户信誉值
lastrepu = repu;                                %上一次repu的值
qual = ones(1,prolen);                          %电影评分值
lastqual = qual;                                %上一次qual的值
indexall = 100000;                              %循环次数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 为了避免无限计算 这里用for循环 
% 将循环次数设置很大 当repu和qual不更新 则退出循环
% 如果用while循环，当repu和qual始终更新时 程序将会一直执行下去
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for index =1:indexall                       %循环计算
    for i = 1:prolen                        %循环计算每部电影的quality
        tt = find(links(:,i)~=0);           %找到评分的用户
        qual(i) = sum(repu(tt,1).*links(tt,i))...
            /(sum(repu(tt,1)));             %计算quality
    end
    
    for i = 1:userlen                       %循环计算每个用户的reputation
        tt = find(links(i,:)~=0);           %找到评分的电影
        repu(i) = 1/(sum((qual(1,tt)-links(i,tt))...
            .^2)/(length(tt)));             %计算reputation
    end
    derepu = sum(lastrepu - repu);          %计算当前时刻与上一时刻的reputation差值
    dequal = sum(lastqual - qual);          %计算当前时刻与上一时刻的quality差值
    if((sum(derepu)+sum(dequal))==0)        %requtation与quality保持不变
        break;                              %退出循环
    else
        lastrepu = repu;                    %保留当前的reputation
        lastqual = qual;                    %保留当前的quality
    end
    disp(['第' num2str(index) '次循环计算']) %输出当前循环次数
end
figure(1)                                   %绘图句柄
plot(1:userlen,repu)                        %绘制用户reputation          
title('用户reputation')                     %添加标题
xlabel('用户id')                            %添加x轴名称
ylabel('reputation')                        %添加y轴名称
figure(2)                                   %绘图句柄
plot(1:prolen,qual)                         %绘制电影quality          
title('电影quality')                        %添加标题
xlabel('电影id')                            %添加x轴名称
ylabel('quality')                           %添加y轴名称
maxrepu = max(repu);                        %reputation最大值
maxrepuid = find(repu == maxrepu );         %reputation最大的用户
maxqual = max(qual);                        %quality最大值
maxqualid = find(qual == maxqual );         %quality最大的电影
disp(['id为：' num2str(maxrepuid) ' 的用户reputation最大，reputation为：' ...
    num2str(maxrepu)])                      %reputation最大的用户
disp(['id为：' num2str(maxqualid) ])                      
disp([' 的电影quality最大，quality为：' ...
    num2str(maxqual)])                      %quality最大的电影

minrepu = min(repu);                        %reputation最小值
minrepuid = find(repu == minrepu );         %reputation最小的用户
minqual = min(qual);                        %quality最小值
minqualid = find(qual == minqual );         %quality最小的电影
disp(['id为：' num2str(minrepuid) ' 的用户reputation最小，reputation为：' ...
    num2str(minrepu)])                      %reputation最小的用户
disp(['id为：' num2str(minqualid) ])                      
disp([' 的电影quality最小，quality为：' ...
    num2str(minqual)])                      %quality最小的电影
