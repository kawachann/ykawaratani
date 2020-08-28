function [entireOnTasksteering,entireMWsteering,entireMWspeed,entireOnTaskspeed,entireOnTaskstdspeed,entireMWstdspeed,entireOnTaskaccel,entireMWaccel,handringresult]=getaction(car1,car2,highRT,lowRT,entireOnTasksteering,entireMWsteering,entireMWspeed,entireOnTaskspeed,entireOnTaskstdspeed,entireMWstdspeed,entireOnTaskaccel,entireMWaccel)
stdOnTasksteeringlabel=[];
stdOnTaskspeedlabel=[];
stdMWsteeringlabel=[];
stdMWspeedlabel=[];
aveMWspeedlabel=[];
aveOnTaskspeedlabel=[];
stdOnTaskaccellabel=[];
stdMWaccellabel=[];

for v=1:length(lowRT)
    OnTasksteering=[];
    OnTaskspeed=[];
    OnTaskaccel=[];
    
    for w=1:length(car1)
       if lowRT(1,v)-car1(1,w)>0 && lowRT(1,v)-car1(1,w)<=10
          OnTasksteering=horzcat(OnTasksteering,car1(6,w)*1800/pi);
          OnTaskspeed=horzcat(OnTaskspeed,car1(5,w));
          OnTaskaccel=horzcat(OnTaskaccel,car1(7,w)*100);
       end
    end
    aveOnTaskspeedlabel=horzcat(aveOnTaskspeedlabel,mean(OnTaskspeed));
    stdOnTasksteeringlabel=horzcat(stdOnTasksteeringlabel,std(OnTasksteering));
    stdOnTaskspeedlabel=horzcat(stdOnTaskspeedlabel,std(OnTaskspeed));
    stdOnTaskaccellabel=horzcat(stdOnTaskaccellabel,std(OnTaskaccel));
end

for v=1:length(highRT) 
  
   MWsteering=[];
   MWspeed=[];
   MWaccel=[];
    for w=1:length(car1)
       if highRT(1,v)-car1(1,w)>0 && highRT(1,v)-car1(1,w)<10
          MWsteering=horzcat(MWsteering,car1(6,w)*1800/pi);
          MWspeed=horzcat(MWspeed,car1(5,w));
          MWaccel=horzcat(MWaccel,car1(7,w)*100);
       end  
    end
    aveMWspeedlabel=horzcat(aveMWspeedlabel,mean(MWspeed));
    stdMWsteeringlabel=horzcat(stdMWsteeringlabel,std(MWsteering));
    stdMWspeedlabel=horzcat(stdMWspeedlabel,std(MWspeed));
     stdMWaccellabel=horzcat(stdMWaccellabel,std(MWaccel));
end
entireOnTaskspeed=vertcat(entireOnTaskspeed,mean(aveOnTaskspeedlabel));
entireMWspeed=vertcat(entireMWspeed,mean(aveMWspeedlabel));
entireOnTaskstdspeed=vertcat(entireOnTaskstdspeed,mean(stdOnTaskspeedlabel));
entireMWstdspeed=vertcat(entireMWstdspeed,mean(stdMWspeedlabel));
entireOnTasksteering=vertcat(entireOnTasksteering,mean(stdOnTasksteeringlabel));
entireMWsteering=vertcat(entireMWsteering,mean(stdMWsteeringlabel));
entireOnTaskaccel=vertcat(entireOnTaskaccel,mean(stdOnTaskaccellabel));
entireMWaccel=vertcat(entireMWaccel,mean(stdMWaccellabel));

handringresult=table([mean(aveOnTaskspeedlabel);mean(aveMWspeedlabel);mean(stdOnTaskspeedlabel);mean(stdMWspeedlabel);mean(stdOnTasksteeringlabel);mean(stdMWsteeringlabel);mean(stdOnTaskaccellabel);mean(stdMWaccellabel)],'VariableNames',{'value'},'RowNames',{'OnTaskspeed' 'MWspeed' 'OnTaskspeedstd' 'MWspeedstd' 'OnTasksteering' 'MWsteering' 'OnTaskaccel' 'MWaccel'});

end
