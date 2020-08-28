function[MWNIRS,OnTaskNIRS]=getnirsdata(highRT,lowRT,hb,NIRx)
 
MWNIRS=[];
OnTaskNIRS=[];
MWnumber=[];
OnTasknumber=[];
for i=1:length(highRT)
     for j=1:length(NIRx)
         if highRT(1,i)-NIRx(1,j)<10&&highRT(1,i)-NIRx(1,j)>0
            MWnumber=horzcat(MWnumber,NIRx(2,j));
         end
     end
 end
 
for i=1:length(lowRT)
     for j=1:length(NIRx)
         if lowRT(1,i)-NIRx(1,j)<10&&lowRT(1,i)-NIRx(1,j)>0
            OnTasknumber=horzcat(OnTasknumber,NIRx(2,j));
         end
     end
end
 
 for s=1:length(MWnumber)
    MWNIRS=horzcat(MWNIRS,NIRx(:,MWnumber(1,s)));
 end
 for s=1:length(OnTasknumber)
    OnTaskNIRS=horzcat(OnTaskNIRS,NIRx(:,OnTasknumber(1,s)));
 end
end