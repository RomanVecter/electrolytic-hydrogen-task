%%清理工作区数据
clear;                %清除所有变量
close all;                %清图
clc;
load('data.mat','P','y','P_el', 'H2','P_el_1', 'H2_1');
%%已经明确定义的参数设置
er=0.7203;
eg=0.2857;
ep=0.5424;
cw=5.8;
cel=7200;
ctan=1500;
Vel=750;
Vh=150;
LP=10;
r=0.06;
ch=40;
%%未有明确定义的参数
Np=5;%电解槽的工作年限
Prate=100;%电解槽额定功率MW
[x1,y1,x2,y2]=Find_FUC(P,y,Prate); 
Etan=Prate*y2/100*2; %电解槽额定容量MWh
Pel=0;%电解槽运行功率MW
Mh2=0;%电解槽氢气产量kg
% Pw=0;%风电理论出力
% pw=0;%风电实际出力
Ei=0;%购电电量
%%
t=0:1:24;
WEP=[225,300,320,450,340,0,0,0,0,0,0,50,225,50,0,0,0,0,0,0,0,0,0,0,225];
%%
%%ABC求解
%%ABC参数设置
nPop=50;%%引领蜂数目
nOnlooker=50;%%跟随蜂群数目
MaxIt=1000;%%最大迭代次数
a=1; %加速度上限
L=10;%%定义侦查蜂阈值跳出局部最优
nVar=24;%%变量个数
VarMin=zeros(1,nVar);%%变量下限
VarMax=100*ones(1,nVar);%%变量上限
%初始化操作
%定义单个蜜源
empty_bee.Position=[];
empty_bee.Cost=[];
%%初始化蜜源数组
pop=repmat(empty_bee,nPop,1);
%%构建全局最优解
BestSol.Cost=inf;
%%创建初始蜜源
for i=1:nPop
    for j=1:nVar
    pop(i).Position(j)=unifrnd(VarMin(j),VarMax(j));
    if pop(i).Position(j)<(VarMax(j)/2)
        pop(i).Position(j)=VarMin(j);
    else
        pop(i).Position(j)=VarMax(j);
    end
    end
    [pop(i).Position,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(pop(i).Position,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP);
    pop(i).Cost=ALL_1;
    if pop(i).Cost<=BestSol.Cost
        BestSol=pop(i);
    end  
end
%%放弃计数器
C=zeros(nPop,1);
for it=1:MaxIt
     %%引领蜂
   for i=1:nPop
       %%选择一个不等于i的k值
       K=[1:i-1 i+1:nPop];
       k=K(randi([1 size(K,2)]));
       %%定义加速度系数
       phi=a*unifrnd(-1,1,1,nVar);
       %%搜索到的新解,更新蜜源
       newbee.Position=pop(i).Position+ phi.*(pop(i).Position- pop(k).Position);
       for j=1:nVar
       if newbee.Position(j)<(VarMax(j)/2)
        newbee.Position(j)=VarMin(j);
       else
        newbee.Position(j)=VarMax(j);
       end 
       end
       %%计算适应度
       [newbee.Position,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(newbee.Position,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP);
       newbee.Cost=ALL_1;
       
       %%贪婪比较
      if newbee.Cost<=pop(i).Cost
        pop(i)=newbee;
      else
         C(i)=C(i)+1; %%此处有问题
     end 
   end
   %%计算适应度概率
   F=zeros(nPop,1);
   MeadCost=mean([pop.Cost]);%%求平均适应度
   for i=1:nPop
       F(i)=exp(-pop(i).Cost/MeadCost);
   end
   Prct=F/sum(F);
   %轮盘赌产生跟随蜂
   for m=1:nOnlooker
       i=lunpandu(Prct);
        k= randi([1, nPop]);
            if k == i
              k= randi([1, nPop]);
            end
       %定义加速度系数
       phi=a*unifrnd(-1,1,1,nVar);
       
       %%搜索到的新解,更新蜜源
       newbee.Position=pop(i).Position+ phi.*(pop(i).Position-pop(k).Position);
       for j=1:nVar
       if newbee.Position(j)<(VarMax(j)/2)
        newbee.Position(j)=VarMin(j);
       else
        newbee.Position(j)=VarMax(j);
       end 
       end 
       
       %%计算适应度
       [newbee.Position,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(newbee.Position,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP);
       newbee.Cost=ALL_1;
       
       %%贪婪比较
      if newbee.Cost<=pop(i).Cost
        pop(i)=newbee;
      else
         C(i)=C(i)+1; %%此处有问题
     end 
   end
   %%侦查蜂 筛选在整个迭代过程中更新了L次依没有跳出局部的蜜源，并随机更新为新蜜源
    for i=1:nPop
       if C(i)>=L
           for j=1:nVar
               pop(i).Position(j)=unifrnd(VarMin(j),VarMax(j));
               if pop(i).Position(j)<(VarMax(j)/2)
                pop(i).Position(j)=VarMin(j);
               else
                pop(i).Position(j)=VarMax(j);
               end
           end
           [pop(i).Position,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(pop(i).Position,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP);
           pop(i).Cost=ALL_1;
           C(i)=0;
       end
    end
       %%更新全局最优解
   for i=1:nPop
    if pop(i).Cost<=BestSol.Cost
        BestSol=pop(i);
    end
   end
  BestCost(it)=BestSol.Cost;
end
disp('方案三计算完成');
BestSol.Position(25)=BestSol.Position(1);
Scheme_3=BestSol.Position;
save('data1.mat','Scheme_3');