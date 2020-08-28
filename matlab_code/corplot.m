function[entiremwrate,entireBRTrate]=corplot(entiremwrate,entireBRTrate,Presen,BRT1)
%時間ブロックのMW率算出-----------------------------------------------------

t1=0;

mwrate=[];
for a=1:15
    R=0;
    MW=0;
    for b=1:length(Presen)-1
        if Presen(1,b)>t1&&Presen(1,b)<(t1+120)&&Presen(2,b)==5
            R=R+1;
            if Presen(2,b+1)==2
               MW=MW+1;
            end
        end
    end
    t1=t1+120;
    mwrate(a)=(MW/R)*100;
end
entiremwrate=vertcat(entiremwrate,mwrate);

t2=0;
BRT=[];

for a=1:15
    BRT=[];
    for b=1:length(BRT1)
        if BRT1(1,b)>t2&&BRT1(1,b)<(t2+120)
            BRT=horzcat(BRT,BRT1(2,b));
        end
    end
    t2=t2+120;
    BRTrate(a)=mean(BRT);
end

entireBRTrate=vertcat(entireBRTrate,BRTrate);
end
