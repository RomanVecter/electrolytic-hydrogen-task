function [Scheme_0,F1_1,F2_1,F3_1,I_1,ALL_1]=Scheme3_FUC(Scheme_0,r,LP,Np,cel,ctan,Vel,Vh,ch,er,eg,ep,Prate,Etan,t,P,y,WEP)
fsc=(r*(1+r)^LP)/((1+r)^LP-1)/Np;
Scheme_2=Scheme_0;
f1_1=(cel*Prate+ctan*Etan)*fsc/10000;
H=zeros(1,(length(t)-1));
f2=zeros(1,(length(t)-1));
for i=1:length(t)-1
   [~,~,~,y2]=Find_FUC(P,y,Scheme_2(i)); 
   H(i)=Scheme_2(i)*y2/100*2;
   f2(i)=(Vel*Scheme_2(i)/100+Vh*H(i)/100)*fsc/24;
end
f2_1=3.335*sum(f2);%%方案三系数为3.335
Mh2_1=sum(H)/24/1.33523;%%方案三系数为1.33523
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
F3_1=2.5*sum(f3);%%方案三系数为2.5
I_1=ch*Mh2_1/10/1.00326;
ALL_1=F1_1+F2_1+F3_1-I_1;