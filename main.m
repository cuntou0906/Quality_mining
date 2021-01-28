clear;clc;                                      %������ݺͼ�¼
moviedata = importdata('movielens.txt');        %�����ļ�
usermin = min(moviedata(:,1));                  %�û���Сid
usermax = max(moviedata(:,1));                  %�û�����id
promin = min(moviedata(:,2));                   %��Ӱ��С��id
promax = max(moviedata(:,2));                   %��Ӱ����id
userlen = usermax-usermin+1;                    %�û���Ŀ
prolen = promax-promin+1;                       %��Ӱ��Ŀ
links = zeros(usermax-usermin+1,promax-promin+1);%��ʼ���û����ֵ��Զ�Ӧ����
for i = 1:size(moviedata,1)                     %�������ݼ������־���
    links(moviedata(i,1),moviedata(i,2)) = moviedata(i,3);
end
repu = ones(userlen,1);                         %�û�����ֵ
lastrepu = repu;                                %��һ��repu��ֵ
qual = ones(1,prolen);                          %��Ӱ����ֵ
lastqual = qual;                                %��һ��qual��ֵ
indexall = 100000;                              %ѭ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ϊ�˱������޼��� ������forѭ�� 
% ��ѭ���������úܴ� ��repu��qual������ ���˳�ѭ��
% �����whileѭ������repu��qualʼ�ո���ʱ ���򽫻�һֱִ����ȥ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for index =1:indexall                       %ѭ������
    for i = 1:prolen                        %ѭ������ÿ����Ӱ��quality
        tt = find(links(:,i)~=0);           %�ҵ����ֵ��û�
        qual(i) = sum(repu(tt,1).*links(tt,i))...
            /(sum(repu(tt,1)));             %����quality
    end
    
    for i = 1:userlen                       %ѭ������ÿ���û���reputation
        tt = find(links(i,:)~=0);           %�ҵ����ֵĵ�Ӱ
        repu(i) = 1/(sum((qual(1,tt)-links(i,tt))...
            .^2)/(length(tt)));             %����reputation
    end
    derepu = sum(lastrepu - repu);          %���㵱ǰʱ������һʱ�̵�reputation��ֵ
    dequal = sum(lastqual - qual);          %���㵱ǰʱ������һʱ�̵�quality��ֵ
    if((sum(derepu)+sum(dequal))==0)        %requtation��quality���ֲ���
        break;                              %�˳�ѭ��
    else
        lastrepu = repu;                    %������ǰ��reputation
        lastqual = qual;                    %������ǰ��quality
    end
    disp(['��' num2str(index) '��ѭ������']) %�����ǰѭ������
end
figure(1)                                   %��ͼ���
plot(1:userlen,repu)                        %�����û�reputation          
title('�û�reputation')                     %��ӱ���
xlabel('�û�id')                            %���x������
ylabel('reputation')                        %���y������
figure(2)                                   %��ͼ���
plot(1:prolen,qual)                         %���Ƶ�Ӱquality          
title('��Ӱquality')                        %��ӱ���
xlabel('��Ӱid')                            %���x������
ylabel('quality')                           %���y������
maxrepu = max(repu);                        %reputation���ֵ
maxrepuid = find(repu == maxrepu );         %reputation�����û�
maxqual = max(qual);                        %quality���ֵ
maxqualid = find(qual == maxqual );         %quality���ĵ�Ӱ
disp(['idΪ��' num2str(maxrepuid) ' ���û�reputation���reputationΪ��' ...
    num2str(maxrepu)])                      %reputation�����û�
disp(['idΪ��' num2str(maxqualid) ])                      
disp([' �ĵ�Ӱquality���qualityΪ��' ...
    num2str(maxqual)])                      %quality���ĵ�Ӱ

minrepu = min(repu);                        %reputation��Сֵ
minrepuid = find(repu == minrepu );         %reputation��С���û�
minqual = min(qual);                        %quality��Сֵ
minqualid = find(qual == minqual );         %quality��С�ĵ�Ӱ
disp(['idΪ��' num2str(minrepuid) ' ���û�reputation��С��reputationΪ��' ...
    num2str(minrepu)])                      %reputation��С���û�
disp(['idΪ��' num2str(minqualid) ])                      
disp([' �ĵ�Ӱquality��С��qualityΪ��' ...
    num2str(minqual)])                      %quality��С�ĵ�Ӱ
