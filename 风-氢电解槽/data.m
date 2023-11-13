%%未调参，遵从论文原始数据
%%清理工作区数据
clear;                %清除所有变量
close all;                %清图
clc;                      %清屏
%% 符号表
% U_cell   单电解槽的直流电压      V
% U_rev    反向电压                V
%r1        电解槽的欧姆电阻        Ω
%r2        电解槽的内电阻          Ω
%T_el      电解槽的温度            K
%A_cell    电解槽面积              cm^2
%I_el      直流电流                A
%S(n) T(n)     电极的过电压系数        n=1,2,3
%%初始化
%数据来源大论文P11
U_rev=1.23;
r1=8.24*10^(-5);
r2=4.21*10^(-7);        
T_el=353.15;           
S=[0.2393,-2.95*10^(-3),1.55*10^(-5)];
T=[0.6767,-0.02711,4.86*10^(-4)];
N_el=25;
ad=0:0.1:2.5;  %%电流密度
%%单电解槽直流电压计算 
U_cell=U_rev+(r1+r2*T_el).*(ad)+(S(1)+S(2)+S(3)*T_el^2)*log(1+((T(1)+T(2)/T_el+T(3)/T_el^2).*(ad)));
V=N_el*U_cell;
figure(1)%%按照论文数据代入与小论文图表存在差距，%%数据太奇怪了
plot(ad,V);
xlabel('电流密度/(A/cm^2)');
ylabel('电压/V');
title('电解槽V—I特性曲线');

%%353.15K效率计算
A_cell=9;  %%数据太奇怪了  
I_el =0:1:150;
U_th=U_rev;%%大论文P8  最小可逆电压也称为热中性电压
U_cell=U_rev+(r1+r2*T_el).*(I_el/A_cell)+(S(1)+S(2)+S(3)*T_el^2)*log(1+((T(1)+T(2)/T_el+T(3)/T_el^2).*(I_el/A_cell)));
ye=U_th./(U_cell);
yF=96.5*exp(0.09./I_el-75.5./I_el.^2);
y=ye.*yF;
P=1.5*(U_cell.*I_el);%%数据太奇怪了
figure(2)%%按照论文数据代入与小论文图表存在差距
plot(P,y,'DisplayName','353.15K');
xlabel('功率/KW');
ylabel('效率/%');
title('电解槽功率效率特性曲线');
xlim([0, 1000]); 
% ylim([0, 35]);
hold on

%%293.15K效率计算
T_el=293.15; 
A_cell=2;  %%数据太奇怪了  
I_el =0:1:150;
U_th=U_rev;%%大论文P8  最小可逆电压也称为热中性电压
U_cell=U_rev+(r1+r2*T_el).*(I_el/A_cell)+(S(1)+S(2)+S(3)*T_el^2)*log(1+((T(1)+T(2)/T_el+T(3)/T_el^2).*(I_el/A_cell)));
ye=U_th./U_cell;
yF=96.5*exp(0.09./I_el-75.5./I_el.^2);
y=ye.*yF;
P=1.23*(U_cell.*I_el);%%数据太奇怪了
plot(P,y,'DisplayName','293.15K');
legend;