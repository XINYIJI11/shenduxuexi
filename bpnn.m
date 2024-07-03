%% ��ջ�������
warning off
close all
clear 
clc

%% ��������
res = xlsread('���ݼ�.xlsx');

%% ����ѵ�����Ͳ��Լ�
temp = randperm(200);

P_train = res(temp(1: 140),1:3)';
T_train = res(temp(1: 140),4)';
M = size(P_train,2);

P_test =  res(temp(141:200),1:3)';
T_test = res(temp(141:200),4)';
N = size(P_test,2);

%% ���ݹ�һ��
[p_train,ps_input] = mapminmax(P_train,0,1);
p_test = mapminmax('apply',P_test,ps_input);

[t_train,ps_output] = mapminmax(T_train,0,1);
t_test = mapminmax('apply',T_test,ps_output);

%% ��������
net = newff(p_train,t_train,5 );

%% ����ѵ������
net.trainparam.epochs = 2000;     %��������
net.trainparam.goal = 1e-6;       %�����ֵ
net.trainparam.lr = 0.001;         %ѧϰ��

%% ѵ������
net = train(net,p_train,t_train);

%% �������
t_sim1 = sim(net,p_train);
t_sim2 = sim(net,p_test);

%% ���ݷ���һ��
T_sim1 = mapminmax('reverse',t_sim1,ps_output);
T_sim2 = mapminmax('reverse',t_sim2,ps_output);

%% ���������
error1= sqrt((sum(T_sim1 - T_train).^2) ./M);
error2= sqrt((sum(T_sim1 - T_train).^2) ./N);

%% ��ͼ
figure
plot(1:M,T_train,'r-*',1:M,T_sim1,'b-o','Linewidth',1)
legend('��ʵֵ','Ԥ��ֵ')
xlabel('Ԥ������')
ylabel('Ԥ����')
string = {'ѵ����Ԥ�����Ա�';['RMSE=' num2str(error1)]};
title(string)
xlim([1,M])
grid

figure
plot(1:N,T_test,'r-*',1:N,T_sim2,'b-o','Linewidth',1)
legend('��ʵֵ','Ԥ��ֵ')
xlabel('Ԥ������')
ylabel('Ԥ����')
string = {'���Լ�Ԥ�����Ա�';['RMSE=' num2str(error2)]};
title(string)
xlim([1,N])
grid



