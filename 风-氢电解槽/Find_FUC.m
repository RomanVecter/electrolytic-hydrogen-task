function [x1,y1,x3,y3]=Find_FUC(P,y,x)
[y1, index] = max(y);
x1=P(index);
x3=x;
isInArray = ismember(x,P);
if isInArray
    in=find(P==x);
    y3=y(in);
else
    if x<P(1)
       y3=y(1);
    else
        i=1;
        while (x>P(i))
            if i>=length(P)
                break
            end
            i=i+1;       
        end
        y3=(y(i)-y(i-1))*((x3-P(i-1))/(P(i)-P(i-1)))+y(i-1);
    end
end