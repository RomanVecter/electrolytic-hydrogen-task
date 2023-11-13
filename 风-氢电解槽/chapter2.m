%第二章 
%%运行文件需要包括
% 主文件chapter2.m 
% 附属文件Find_FUC.m Fuzzy.m
%%清理工作区数据
clear;                %清除所有变量
close all;                %清图
clc; 
%%
%%参数初始化
N=100; %%电解槽数目
%电解槽启动序列
A=zeros(1,N);
%%电解槽功率序列
Prate=zeros(1,N);
%%功率效率曲线
U_rev=1.23;
r1=8.24*10^(-5);
r2=4.21*10^(-7);        
T_el=353.15;           
S=[0.2393,-2.95*10^(-3),1.55*10^(-5)];
T=[0.6767,-0.02711,4.86*10^(-4)];
A_cell=9;  %%数据太奇怪了  
I_el =0:1:150;
U_th=U_rev;%%大论文P8  最小可逆电压也称为热中性电压
U_cell=U_rev+(r1+r2*T_el).*(I_el/A_cell)+(S(1)+S(2)+S(3)*T_el^2)*log(1+((T(1)+T(2)/T_el+T(3)/T_el^2).*(I_el/A_cell)));
ye=U_th./U_cell;
yF=96.5*exp(0.09./I_el-75.5./I_el.^2);
y=ye.*yF;
y(1)=0;
P=4.5*(U_cell.*I_el);%%数据太奇怪了
% figure(1)%%按照论文数据代入与小论文图表存在差距
% plot(P,y,'DisplayName','353.15K');
% xlabel('功率/KW');
% ylabel('效率/%');
% title('电解槽功率效率特性曲线');
% xlim([0, 1000]); 
% ylim([0, 35]);

%%制氢效率功率以大论文353.15K为例子
[x1,y1,~,y2]=Find_FUC(P,y,1000);
PEM= struct('P1', x1/10, 'ymax', y1, 'P2', 1000, 'y0', y2);


%%优化功率
P_el=1:1:100;
H2=zeros(1,length(P_el));
%%传统策略
for k=1:length(P_el)
% i=0;
% while P_el(k)>PEM.P2*nnz(A)
%     i=i+1;
%     A(i)=1;
% end
% Pel=P_el(k)-(nnz(A)-1)*PEM.P2;
% [x1,y1,x2,y2]=Find_FUC(P,y,Pel);
% %%制氢量计算
% H2(k)=(nnz(A)-1)*PEM.P2*PEM.y0*0.01+Pel*y2*0.01;
[x1,y1,x2,y2]=Find_FUC(P,y,P_el(k)+25);
%disp(['递归' sprintf( '%f',y2) '次']);
H2(k)=P_el(k)*y2;
end
pty=1600;
H2= H2/pty;
figure(2)%%按照论文数据代入与小论文图表存在差距
plot(P_el, H2, 'b','DisplayName','简单启停法','LineWidth', 1)
hold on


%%模糊控制
[x1,y1,x2,y2]=Find_FUC(P,y,1000);
P_el_1=0:10:100000;
H2_1=zeros(1,length(P_el));
for k=1:length(P_el_1)
    if P_el_1(k)==0
%         A=zeros(1,N);
%         i=nnz(A);
%         while(i<100)
%             i=i+1;
%         end
        H2_1(k)=0;
    elseif (P_el_1(k)>0)&&(P_el_1(k)<=N*x1)
        e=P_el_1(k)/100;
        [x1,y1,x2,y2]=Find_FUC(P,y,e);
        H2_1(k)=P_el_1(k)*y2; 
    elseif (P_el_1(k)>N*x1)&&(P_el_1(k)<=N*1000)
          e=P_el_1(k)/100;
        [x1,y1,x2,y2]=Find_FUC(P,y,e);
        H2_1(k)=P_el_1(k)*y2;
    end
end
P_el_1=P_el_1/1000;
H2_1=H2_1/1000/pty;
plot(P_el_1, H2_1, '--r','DisplayName','分段模糊控制法','LineWidth', 1)
legend('Location', 'NorthWest');
xlabel('功率/MW');
ylabel('制氢量/t)');
P=P/10;
save('data.mat','P','y','P_el', 'H2','P_el_1', 'H2_1');