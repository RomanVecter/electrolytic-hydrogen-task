%%������������
clear;                %������б���
close all;                %��ͼ
clc;
load('data.mat','P','y','P_el', 'H2','P_el_1', 'H2_1');
%%�Ѿ���ȷ����Ĳ�������
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
%%δ����ȷ����Ĳ���
Np=5;%���۵Ĺ�������
Prate=100;%���۶����MW
[x1,y1,x2,y2]=Find_FUC(P,y,Prate); 
Etan=Prate*y2/100*2; %���۶����MWh
Pel=0;%�������й���MW
Mh2=0;%������������kg
% Pw=0;%������۳���
% pw=0;%���ʵ�ʳ���
Ei=0;%�������
%%
t=0:1:24;
WEP=[225,300,320,450,340,0,0,0,0,0,0,50,225,50,0,0,0,0,0,0,0,0,0,0,225];
%%
%%ABC���
%%ABC��������
nPop=50;%%�������Ŀ
nOnlooker=50;%%�����Ⱥ��Ŀ
MaxIt=1000;%%����������
a=1; %���ٶ�����
L=10;%%����������ֵ�����ֲ�����
nVar=24;%%��������
VarMin=zeros(1,nVar);%%��������
VarMax=100*ones(1,nVar);%%��������
%��ʼ������
%���嵥����Դ
empty_bee.Position=[];
empty_bee.Cost=[];
%%��ʼ����Դ����
pop=repmat(empty_bee,nPop,1);
%%����ȫ�����Ž�
BestSol.Cost=inf;
%%������ʼ��Դ
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
%%����������
C=zeros(nPop,1);
for it=1:MaxIt
     %%�����
   for i=1:nPop
       %%ѡ��һ��������i��kֵ
       K=[1:i-1 i+1:nPop];
       k=K(randi([1 size(K,2)]));
       %%������ٶ�ϵ��
       phi=a*unifrnd(-1,1,1,nVar);
       %%���������½�,������Դ
       newbee.Position=pop(i).Position+ phi.*(pop(i).Position- pop(k).Position);
       for j=1:nVar
       if newbee.Position(j)<(VarMax(j)/2)
        newbee.Position(j)=VarMin(j);
       else
        newbee.Position(j)=VarMax(j);
       end 
       end
       %%������Ӧ��
       [newbee.Position,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(newbee.Position,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP);
       newbee.Cost=ALL_1;
       
       %%̰���Ƚ�
      if newbee.Cost<=pop(i).Cost
        pop(i)=newbee;
      else
         C(i)=C(i)+1; %%�˴�������
     end 
   end
   %%������Ӧ�ȸ���
   F=zeros(nPop,1);
   MeadCost=mean([pop.Cost]);%%��ƽ����Ӧ��
   for i=1:nPop
       F(i)=exp(-pop(i).Cost/MeadCost);
   end
   Prct=F/sum(F);
   %���̶Ĳ��������
   for m=1:nOnlooker
       i=lunpandu(Prct);
        k= randi([1, nPop]);
            if k == i
              k= randi([1, nPop]);
            end
       %������ٶ�ϵ��
       phi=a*unifrnd(-1,1,1,nVar);
       
       %%���������½�,������Դ
       newbee.Position=pop(i).Position+ phi.*(pop(i).Position-pop(k).Position);
       for j=1:nVar
       if newbee.Position(j)<(VarMax(j)/2)
        newbee.Position(j)=VarMin(j);
       else
        newbee.Position(j)=VarMax(j);
       end 
       end 
       
       %%������Ӧ��
       [newbee.Position,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(newbee.Position,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP);
       newbee.Cost=ALL_1;
       
       %%̰���Ƚ�
      if newbee.Cost<=pop(i).Cost
        pop(i)=newbee;
      else
         C(i)=C(i)+1; %%�˴�������
     end 
   end
   %%���� ɸѡ���������������и�����L����û�������ֲ�����Դ�����������Ϊ����Դ
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
       %%����ȫ�����Ž�
   for i=1:nPop
    if pop(i).Cost<=BestSol.Cost
        BestSol=pop(i);
    end
   end
  BestCost(it)=BestSol.Cost;
end
disp('�������������');
BestSol.Position(25)=BestSol.Position(1);
Scheme_3=BestSol.Position;
save('data1.mat','Scheme_3');