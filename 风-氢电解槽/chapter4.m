%������
%%�����ļ���Ҫ����
% ���ļ�chapter4.m 
% �����ļ�Find_FUC.m 
%�����ļ� data3.mat
%%������������
clear;                %������б���
close all;                %��ͼ
clc;
%%��������
load('data3.mat','WEP','Scheme_4');
%��ͼ
figure(1);
t=0:1:24;
plot(t, WEP,'*r-','DisplayName','���繦��')
hold on
plot(t,Scheme_4,'go-','DisplayName','���⹦��');
set(gcf, 'Position', [280, 130, 1200, 600]);
xticks(0:24);  % �̶�λ�ô�0��24
xticklabels({'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'});
xlabel('ʱ��/h');
ylabel('����/MW');
title('���ַ������⹦������');
xlim([0, 24]); 
ylim([0, 450]);
legend;
%%����
%%������ʼ��
N=100; %%������Ŀ
%������������
A=ones(1,N);
%%���۹�������
P_tr=zeros(1,N);
%%�����
Prate=1;%%�˴���λΪMW
%%��ȡ�������⹦��
load('data.mat','P','y');
P=P*3.56;
[x1,y1,x2,y2]=Find_FUC(P,y,Prate*1000); 
Yrate=y2;
P0=x1/1000;
Ymax=y1;
%%��ͼ
t=1:1:3600;
Pmax=Prate*ones(1,length(t));
Pout=P0*ones(1,length(t));
Number=length(t);
%%һ��Сʱ�ڵ����繦������
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
xlabel('ʱ��/s');
ylabel('����/MW');
title('a)���ڶ���ʵĵ��۹���');
subplot(3,2,2)
plot(t, Pout);
xlim([0, 3600]); 
ylim([0, 1.5]);
xlabel('ʱ��/s');
ylabel('����/MW');
title('b)�������Ź��ʵĵ��۹���');
subplot(3,2,3)
plot(t, Number_Pmax);
xlim([0, 3600]); 
ylim([20, 80]);
xlabel('ʱ��/s');
ylabel('����');
title('c)���ڶ���ʵĵ��۸���');
subplot(3,2,4)
plot(t, Number_Pout);
xlim([0, 3600]); 
ylim([20, 80]);
xlabel('ʱ��/s');
ylabel('����');
title('d)�������Ź��ʵĵ��۸���');
subplot(3,2,5)
plot(t, P_bd);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('ʱ��/s');
ylabel('����/MW');
title('e)���ڲ������ʵĵ��۹���');
subplot(3,2,6)
plot(t, Pdp);
xlim([0, 3600]); 
ylim([35, 69]);
xlabel('ʱ��/s');
ylabel('����/MW');
title('f)���繦������');
%%�ֻ����Ʋ���
%%������ز���
%%������ʱ��
T0=3600;
%%�ֻ�����
T=300;
A1=ones(1,Number);%%����1���ʼ�¼
A2=ones(1,Number);%%����2���ʼ�¼
A3=ones(1,Number);%%����3���ʼ�¼
A4=ones(1,Number);%%����4���ʼ�¼
%%0Ϊ��Ъ����
%%0.5Ϊ���Ź�������
%%1Ϊ���������
%%1.5Ϊ���ع�������
%%2Ϊ������������
for i=1:1:Number
    P_el=Pdp(i);
    if (P_el>=N*Prate)
        %%���ع���
        A=ones(1,N);
        P_tr=Prate*ones(1,N);
        %disp("��ǰ����Ϊ���ع���");
        L=2*N/5;
        k=N-L;
        u=(P_el-N*Prate)/L/Prate+1;
        %��ʼ״̬
        %���ع�������
        A(1:L)=1.5;
        P_tr(1:L)=u*Prate;  
    else
        if (P_el>=N*P0)
            %%�����빤��
            A=ones(1,N);
            P_tr=Prate*ones(1,N);
            %disp("��ǰ����Ϊ�����빤��");
            k=floor(P_el);
            L=N-1-k;
            Pb=P_el-k-L*P0;
            while (Pb<0)
                k=k-1;
                L=L+1;
                Pb=P_el-k-L*P0;
            end
            %%��ʼ״̬
            %������������
            A(1)=2;
            P_tr(1)=Pb;
            %���������
            A(2:k+1)=1;
            P_tr(2:k+1)=Prate;
            %���Ź�������
            A(k+2:N)=0.5;
            P_tr(k+2:N)=P0;           
%             %���������
%             A(1:k)=1;
%             P_tr(1:k)=Prate;
%             %���Ź�������
%             A(k+1:N-1)=0.5;
%             P_tr(k+1:N-1)=P0;
%             %������������
%             A(N)=2;
%             P_tr(N)=Pb;           
        else
            %%�����빤��
            A=ones(1,N);
            P_tr=Prate*ones(1,N);
            %disp("��ǰ����Ϊ�����빤��");
            k=floor(P_el/P0);
            Pb=P_el-k*P0;
            L=N-1-k;
            %%��ʼ״̬
            %���Ź�������
            A(1:k)=0.5;
            P_tr(1:k)=P0;
            %��Ъ����
            A(k+1:N-1)=0;
            P_tr(k+1:N-1)=P0;
            %������������
            A(N)=2;
            P_tr(N)=Pb;
        end
    end
    %ʱ�为��
        nt=floor(i/T);%�жϵڼ�������
        %%�ֻ�nt��
        for gc=1:nt
        A=[A(N),A(1:N-1)];
        P_tr=[P_tr(N), P_tr(1:N-1)];
        end
    %%ÿ1s��¼
    A1(i)=P_tr(1);
    A2(i)=P_tr(2);
    A3(i)=P_tr(3);
    A4(i)=P_tr(4);
end
%%��ͼ
figure(3)
set(gcf, 'Position', [280, 130, 1200, 600]);
subplot(2,2,1)
plot(t, A1);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('ʱ��/s');
ylabel('����/MW');
title('����a1');
subplot(2,2,2)
plot(t, A2);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('ʱ��/s');
ylabel('����/MW');
title('����a2');
subplot(2,2,3)
plot(t, A3);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('ʱ��/s');
ylabel('����/MW');
title('����a3');
subplot(2,2,4)
plot(t, A4);
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('ʱ��/s');
ylabel('����/MW');
title('����a4');
figure(4)
plot(t, Pmax,'r-','DisplayName','���ڶ���ʵĵ���');
hold on
plot(t, Pout,'k-','DisplayName','�������Ź��ʵĵ���');
plot(t, P_bd,'b-','DisplayName','���ڲ������ʹ��ʵĵ���');
xlim([0, 3600]); 
ylim([0, 1]);
xlabel('ʱ��/s');
ylabel('����/MW');
figure(5)
plot(t(1:T), A1(1:T),'color', [0.2, 0.8, 0.8],'DisplayName','����a1');
hold on
plot(t(T+1:2*T), A2(T+1:2*T),'color', [0.7, 0.6, 0.2],'DisplayName','����a2');
plot(t(2*T+1:3*T), A3(2*T+1:3*T),'color', [0.1, 0.9, 0.4],'DisplayName','����a3');
plot(t(3*T+1:4*T), A4(3*T+1:4*T),'color', [0.2, 0.2, 0.6],'DisplayName','����a4');
xlim([0, 1200]); 
ylim([0, 1]);
xlabel('ʱ��/s');
ylabel('����/MW');