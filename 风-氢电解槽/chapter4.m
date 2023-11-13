%第四章
%%运行文件需要包括
% 主文件chapter4.m 
% 附属文件Find_FUC.m 
%数据文件 data3.mat
%%清理工作区数据
clear;                %清除所有变量
close all;                %清图
clc;
%%加载数据
load('data3.mat','WEP','Scheme_4');
%绘图
figure(1);
t=0:1:24;
plot(t, WEP,'*r-','DisplayName','弃风功率')
hold on
plot(t,Scheme_4,'go-','DisplayName','制氢功率');
set(gcf, 'Position', [280, 130, 1200, 600]);
xticks(0:24);  % 刻度位置从0到24
xticklabels({'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'});
xlabel('时间/h');
ylabel('功率/MW');
title('四种方案制氢功率曲线');
xlim([0, 24]); 
ylim([0, 450]);
legend;
%%电解槽
%%参数初始化
N=100; %%电解槽数目
%电解槽启动序列
A=ones(1,N);
%%电解槽功率序列
P_tr=zeros(1,N);
%%额定功率
Prate=1;%%此处单位为MW
%%获取最优制氢功率
load('data.mat','P','y');
P=P*3.56;
[x1,y1,x2,y2]=Find_FUC(P,y,Prate*1000); 
Yrate=y2;
P0=x1/1000;
Ymax=y1;
%%绘图
t=1:1:3600;
Pmax=Prate*ones(1,length(t));
Pout=P0*ones(1,length(t));
Number=length(t);
%%一个小时内的弃风功率曲线
Pdp=unifrnd(35,70,1,Number);
Pdp(1:600)=unifrnd(35,45,1,600);
Pdp(1001:1300)=unifrnd(45,60,1,300);
Pdp(2501:2600)=unifrnd(60,70,1,100);
Number_Pmax=ones(1,Number);
Number_Pout=ones(1,Number);
P_bd=zeros(1,Number);
%%
for i=1:1:3600
    udp=floor(Pdp(i));
    Number_Pmax(i)=udp;
    Number_Pout(i)=100-1-Number_Pmax(i);
    P_bd(i)=Pdp(i)-Number_Pmax(i)-Number_Pout(i)*P0;
    while (P_bd(i)<0)
        Number_Pmax(i)=Number_Pmax(i)-1;
        Number_Pout(i)=Number_Pout(i)+1;
        P_bd(i)=Pdp(i)-Number_Pmax(i)-Number_Pout(i)*P0;
    end
end
%%
figure(2)
set(gcf, 'Position', [280, 130, 1200, 600]);
subplot(3,2,1)
plot(t, Pmax);
xlim([0, 3600]); 
ylim([0, 1.5]);
xlabel('时间/s');
ylabel('功率/MW');
title('a)处于额定功率的电解槽功率');
subplot(3,2,2)
plot(t, Pout);
xlim([0, 3600]); 
ylim([0, 1.5]);
xlabel('时间/s');
ylabel('功率/MW');
title('b)处于最优功率的电解槽功率');
subplot(3,2,3)
plot(t, Number_Pmax);
xlim([0, 3600]); 
ylim([20, 80]);
xlabel('时间/s');
ylabel('个数');
title('c)处于额定功率的电解槽个数');
subplot(3,2,4)
plot(t, Number_Pout);
xlim([0, 3600]); 
ylim([20, 80]);
xlabel('时间/s');
ylabel('个数');
title('d)处于最优功率的电解槽个数');
subplot(3,2,5)
plot(t, P_bd);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('时间/s');
ylabel('功率/MW');
title('e)处于波动功率的电解槽功率');
subplot(3,2,6)
plot(t, Pdp);
xlim([0, 3600]); 
ylim([35, 69]);
xlabel('时间/s');
ylabel('功率/MW');
title('f)弃风功率曲线');
%%轮换控制策略
%%定义相关参数
%%总运行时长
T0=3600;
%%轮换周期
T=300;
A1=ones(1,Number);%%电解槽1功率记录
A2=ones(1,Number);%%电解槽2功率记录
A3=ones(1,Number);%%电解槽3功率记录
A4=ones(1,Number);%%电解槽4功率记录
%%0为间歇运行
%%0.5为最优功率运行
%%1为额定功率运行
%%1.5为过载功率运行
%%2为波动功率运行
for i=1:1:Number
    P_el=Pdp(i);
    if (P_el>=N*Prate)
        %%过载工况
        A=ones(1,N);
        P_tr=Prate*ones(1,N);
        %disp("当前工况为过载工况");
        L=2*N/5;
        k=N-L;
        u=(P_el-N*Prate)/L/Prate+1;
        %初始状态
        %过载功率运行
        A(1:L)=1.5;
        P_tr(1:L)=u*Prate;  
    else
        if (P_el>=N*P0)
            %%高输入工况
            A=ones(1,N);
            P_tr=Prate*ones(1,N);
            %disp("当前工况为高输入工况");
            k=floor(P_el);
            L=N-1-k;
            Pb=P_el-k-L*P0;
            while (Pb<0)
                k=k-1;
                L=L+1;
                Pb=P_el-k-L*P0;
            end
            %%初始状态
            %波动功率运行
            A(1)=2;
            P_tr(1)=Pb;
            %额定功率运行
            A(2:k+1)=1;
            P_tr(2:k+1)=Prate;
            %最优功率运行
            A(k+2:N)=0.5;
            P_tr(k+2:N)=P0;           
%             %额定功率运行
%             A(1:k)=1;
%             P_tr(1:k)=Prate;
%             %最优功率运行
%             A(k+1:N-1)=0.5;
%             P_tr(k+1:N-1)=P0;
%             %波动功率运行
%             A(N)=2;
%             P_tr(N)=Pb;           
        else
            %%低输入工况
            A=ones(1,N);
            P_tr=Prate*ones(1,N);
            %disp("当前工况为低输入工况");
            k=floor(P_el/P0);
            Pb=P_el-k*P0;
            L=N-1-k;
            %%初始状态
            %最优功率运行
            A(1:k)=0.5;
            P_tr(1:k)=P0;
            %间歇运行
            A(k+1:N-1)=0;
            P_tr(k+1:N-1)=P0;
            %波动功率运行
            A(N)=2;
            P_tr(N)=Pb;
        end
    end
    %时变负荷
        nt=floor(i/T);%判断第几个周期
        %%轮换nt次
        for gc=1:nt
        A=[A(N),A(1:N-1)];
        P_tr=[P_tr(N), P_tr(1:N-1)];
        end
    %%每1s记录
    A1(i)=P_tr(1);
    A2(i)=P_tr(2);
    A3(i)=P_tr(3);
    A4(i)=P_tr(4);
end
%%绘图
figure(3)
set(gcf, 'Position', [280, 130, 1200, 600]);
subplot(2,2,1)
plot(t, A1);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('时间/s');
ylabel('功率/MW');
title('电解槽a1');
subplot(2,2,2)
plot(t, A2);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('时间/s');
ylabel('功率/MW');
title('电解槽a2');
subplot(2,2,3)
plot(t, A3);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('时间/s');
ylabel('功率/MW');
title('电解槽a3');
subplot(2,2,4)
plot(t, A4);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('时间/s');
ylabel('功率/MW');
title('电解槽a4');
figure(4)
plot(t, Pmax,'r-','DisplayName','处于额定功率的电解槽');
hold on
plot(t, Pout,'k-','DisplayName','处于最优功率的电解槽');
plot(t, P_bd,'b-','DisplayName','处于波动功率功率的电解槽');
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('时间/s');
ylabel('功率/MW');
figure(5)
plot(t(1:T), A1(1:T),'color', [0.2, 0.8, 0.8],'DisplayName','电解槽a1');
hold on
plot(t(T+1:2*T), A2(T+1:2*T),'color', [0.7, 0.6, 0.2],'DisplayName','电解槽a2');
plot(t(2*T+1:3*T), A3(2*T+1:3*T),'color', [0.1, 0.9, 0.4],'DisplayName','电解槽a3');
plot(t(3*T+1:4*T), A4(3*T+1:4*T),'color', [0.2, 0.2, 0.6],'DisplayName','电解槽a4');
xlim([0, 1200]); 
ylim([0, 1]);
xlabel('时间/s');
ylabel('功率/MW');