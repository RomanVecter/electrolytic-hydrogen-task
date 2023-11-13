function i=lunpandu(P)
    r=rand;
    C=cumsum(P);
    i=find(r<=C,1);
end