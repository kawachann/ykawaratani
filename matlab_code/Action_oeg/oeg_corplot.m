function[mw1,mw2,mw3,mw4]=oeg_corplot(mw1,mw2,mw3,mw4,Presen,BRT1)
%時間ブロックのMW率算出-----------------------------------------------------


    R1=0;
    MW1=0;
    R2=0;
    MW2=0;
    R3=0;
    MW3=0;
    R4=0;
    MW4=0;
for b=1:length(Presen)-1
        if 0<Presen(1,b)&&Presen(1,b)<450&&Presen(2,b)==5
            R1=R1+1;
            if Presen(2,b+1)==2
               MW1=MW1+1;
            end
        end
         if 450>Presen(1,b)&&Presen(1,b)<900&&Presen(2,b)==5
            R2=R2+1;
            if Presen(2,b+1)==2
               MW2=MW2+1;
            end
         end
         if 900>Presen(1,b)&&Presen(1,b)<1350&&Presen(2,b)==5
            R3=R3+1;
            if Presen(2,b+1)==2
               MW3=MW3+1;
            end
         end
         if 1350>Presen(1,b)&&Presen(1,b)<1800&&Presen(2,b)==5
            R4=R4+1;
            if Presen(2,b+1)==2
               MW4=MW4+1;
            end
         end
end
    
mw1=vertcat(mw1,(MW1/R1)*100);
mw2=vertcat(mw2,(MW2/R2)*100);
mw3=vertcat(mw3,(MW3/R3)*100);
mw4=vertcat(mw4,(MW4/R4)*100);
end
