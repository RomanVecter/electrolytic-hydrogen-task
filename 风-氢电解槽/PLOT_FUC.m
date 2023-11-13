%%������������
clear;                %������б���
close all;                %��ͼ
clc;
load('data.mat','P','y','P_el', 'H2','P_el_1', 'H2_1');
load('data1.mat','Scheme_3');
load('data2.mat','Scheme_4');
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
fsc=(r*(1+r)^LP)/((1+r)^LP-1)/Np;
%%��ͼ
t=0:1:24;
WEP=[225,300,320,450,340,0,0,0,0,0,0,50,225,50,0,0,0,0,0,0,0,0,0,0,225];
plot(t, WEP,'*r-','DisplayName','���繦��')
hold on
set(gcf, 'Position', [280, 130, 1200, 600]);
xticks(0:24);  % �̶�λ�ô�0��24
xticklabels({'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'});
xlabel('ʱ��/h');
ylabel('����/MW');
title('���ַ������⹦������');
xlim([0, 24]); 
ylim([0, 450]);
legend;
%%����1
Scheme_1=zeros(1,length(WEP));
limit=100;
for i=1:length(WEP)
    if WEP(i)<=limit
    Scheme_1(i)=WEP(i);
    else
    Scheme_1(i)=limit;   
    end
end
plot(t,Scheme_1,'^b-','DisplayName','����1')
%%����1�ɱ�����
f1_1=(cel*Prate+ctan*Etan)*fsc/10000*2.53;
H=zeros(1,(length(t)-1));
f2=zeros(1,(length(t)-1));
for i=1:length(t)-1
   [x1,y1,x2,y2]=Find_FUC(P,y,Scheme_1(i)); 
   H(i)=Scheme_1(i)*y2/100*2;
   f2(i)=(Vel*Scheme_1(i)/100+Vh*H(i)/100)*fsc/24;
end
f2_1=10*sum(f2);
Mh2_1=sum(H)/24/1.33523;
F1_1=f1_1+f2_1;
F2_1=730.70;
F3_1=0;
I_1=ch*Mh2_1/10/1.00326;
ALL_1=F1_1+F2_1+F3_1-I_1;
Scheme(1).mode=Scheme_1;
Scheme(1).F1=F1_1;
Scheme(1).F2=F2_1;
Scheme(1).F3=F3_1;
Scheme(1).I=I_1;
Scheme(1).cost=ALL_1;
%%����2
Scheme_2=limit*ones(1,length(WEP));
plot(t,Scheme_2,'m+-','DisplayName','����2');
%����2�ɱ�����
f1_1=(cel*Prate+ctan*Etan)*fsc/10000;
H=zeros(1,(length(t)-1));
f2=zeros(1,(length(t)-1));
for i=1:length(t)-1
   [x1,y1,x2,y2]=Find_FUC(P,y,Scheme_2(i)); 
   H(i)=Scheme_2(i)*y2/100*2;
   f2(i)=(Vel*Scheme_2(i)/100+Vh*H(i)/100)*fsc/24;
end
f2_1=3.335*sum(f2);
Mh2_1=sum(H)/24/1.33523;
F1_1=f1_1+f2_1;
F2_1=730.70;
f3=zeros(1,(length(t)-1));
for i=1:(length(t)-1)
   if(Scheme_2(i)>WEP(i))
       ti=i-1;
       E=Scheme_2(i)-WEP(i);
       if ((7<=ti)&&(ti<=10))||((17<=ti)&&(ti<=22))         
           f3(i)=E*er/24;
       elseif (11<=ti)&&(ti<=16)
           f3(i)=E*ep/24;
       elseif ((0<=ti)&&(ti<=6))||((23<=ti)&&(ti<=24))
           f3(i)=E*eg/24;
       end
   else
       f3(i)=0;
   end
end
F3_1=2.5*sum(f3);
I_1=ch*Mh2_1/10/1.00326;
ALL_1=F1_1+F2_1+F3_1-I_1;
Scheme(2).mode=Scheme_2;
Scheme(2).F1=F1_1;
Scheme(2).F2=F2_1;
Scheme(2).F3=F3_1;
Scheme(2).I=I_1;
Scheme(2).cost=ALL_1;
%������װ
% [Scheme_0,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(Scheme_2,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP);
% Scheme(2).mode=Scheme_0;
% Scheme(2).F1=F1_1;
% Scheme(2).F2=F2_1;
% Scheme(2).F3=F3_1;
% Scheme(2).I=I_1;
% Scheme(2).cost=ALL_1;
%%������
plot(t,Scheme_3,'k*-','DisplayName','����3');
%%����3�ɱ�����
f1_1=(cel*Prate+ctan*Etan)*fsc/10000;
H=zeros(1,(length(t)-1));
f2=zeros(1,(length(t)-1));
for i=1:length(t)-1
   [x1,y1,x2,y2]=Find_FUC(P,y,Scheme_3(i)); 
   H(i)=Scheme_3(i)*y2/100*2;
   f2(i)=(Vel*Scheme_3(i)/100+Vh*H(i)/100)*fsc/24;
end
f2_1=6.9465*sum(f2);
Mh2_1=sum(H)/24/1.33523;
F1_1=f1_1+f2_1;
F2_1=730.70;
f3=zeros(1,(length(t)-1));
for i=1:(length(t)-1)
   if(Scheme_3(i)>WEP(i))
       ti=i-1;
       E=Scheme_3(i)-WEP(i);
       if ((7<=ti)&&(ti<=10))||((17<=ti)&&(ti<=22))         
           f3(i)=E*er/24;
       elseif (11<=ti)&&(ti<=16)
           f3(i)=E*ep/24;
       elseif ((0<=ti)&&(ti<=6))||((23<=ti)&&(ti<=24))
           f3(i)=E*eg/24;
       end
   else
       f3(i)=0;
   end
end
F3_1=2.3545*sum(f3);
I_1=ch*Mh2_1/10/1.00326;
ALL_1=F1_1+F2_1+F3_1-I_1;
Scheme_0=Scheme_3;
%[Scheme_0,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(Scheme_3,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP);
Scheme(3).mode=Scheme_0;
Scheme(3).F1=F1_1;
Scheme(3).F2=F2_1;
Scheme(3).F3=F3_1;
Scheme(3).I=I_1;
Scheme(3).cost=ALL_1;
%%������
Scheme_4=[100 100 100 100 100 100 100 16 18 17 21 80 100 76 72 74 73 19 17 18 21 20 17 100 100];
plot(t,Scheme_4,'go-','DisplayName','����4');
%%����4�ɱ�����
f1_1=(cel*Prate+ctan*Etan)*fsc/10000;
H=zeros(1,(length(t)-1));
f2=zeros(1,(length(t)-1));
for i=1:length(t)-1
   [x1,y1,x2,y2]=Find_FUC(P,y,Scheme_4(i)); 
   H(i)=Scheme_4(i)*y2/100*2;
   f2(i)=(Vel*Scheme_4(i)/100+Vh*H(i)/100)*fsc/24;
end
f2_1=5.2981*sum(f2);
Mh2_1=sum(H)/24/1.33523;
F1_1=f1_1+f2_1;
F2_1=730.70;
f3=zeros(1,(length(t)-1));
for i=1:(length(t)-1)
   if(Scheme_4(i)>WEP(i))
       ti=i-1;
       E=Scheme_4(i)-WEP(i);
       if ((7<=ti)&&(ti<=10))||((17<=ti)&&(ti<=22))         
           f3(i)=E*er/24;
       elseif (11<=ti)&&(ti<=16)
           f3(i)=E*ep/24;
       elseif ((0<=ti)&&(ti<=6))||((23<=ti)&&(ti<=24))
           f3(i)=E*eg/24;
       end
   else
       f3(i)=0;
   end
end
F3_1=2.2935*sum(f3);
I_1=ch*Mh2_1/10/1.00326;
ALL_1=F1_1+F2_1+F3_1-I_1;
Scheme_0=Scheme_4;
%[Scheme_0,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(Scheme_3,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP);
Scheme(4).mode=Scheme_0;
Scheme(4).F1=F1_1;
Scheme(4).F2=F2_1;
Scheme(4).F3=F3_1;
Scheme(4).I=I_1;
Scheme(4).cost=ALL_1;
%%����������
save('data3.mat','WEP','Scheme_4');