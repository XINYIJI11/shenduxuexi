%% 清空环境变量
warning off
close all
clear 
clc

%% 导入数据
res = xlsread('数据集.xlsx');

%% 划分训练集和测试集
temp = randperm(200);

P_train = res(temp(1: 140),1:3)';
T_train = res(temp(1: 140),4)';
M = size(P_train,2);

P_test =  res(temp(141:200),1:3)';
T_test = res(temp(141:200),4)';
N = size(P_test,2);

%% 数据归一化
[p_train,ps_input] = mapminmax(P_train,0,1);
p_test = mapminmax('apply',P_test,ps_input);

[t_train,ps_output] = mapminmax(T_train,0,1);
t_test = mapminmax('apply',T_test,ps_output);

%% 创建网络
net = newff(p_train,t_train,5 );

%% 设置训练参数
net.trainparam.epochs = 2000;     %迭代次数
net.trainparam.goal = 1e-6;       %误差阈值
net.trainparam.lr = 0.001;         %学习率

%% 训练网络
net = train(net,p_train,t_train);

%% 仿真测试
t_sim1 = sim(net,p_train);
t_sim2 = sim(net,p_test);

%% 数据反归一化
T_sim1 = mapminmax('reverse',t_sim1,ps_output);
T_sim2 = mapminmax('reverse',t_sim2,ps_output);

%% 均方根误差
error1= sqrt((sum(T_sim1 - T_train).^2) ./M);
error2= sqrt((sum(T_sim1 - T_train).^2) ./N);

%% 绘图
figure
plot(1:M,T_train,'r-*',1:M,T_sim1,'b-o','Linewidth',1)
legend('真实值','预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'训练集预测结果对比';['RMSE=' num2str(error1)]};
title(string)
xlim([1,M])
grid

figure
plot(1:N,T_test,'r-*',1:N,T_sim2,'b-o','Linewidth',1)
legend('真实值','预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'测试集预测结果对比';['RMSE=' num2str(error2)]};
title(string)
xlim([1,N])
grid



