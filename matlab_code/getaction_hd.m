function [entireOnTaskhd,entireMWhd]=getaction_hd(car1,car2,highRT,lowRT,entireOnTaskhd,entireMWhd)
OnTaskhdlabel=[];
MWhdlabel=[];

for v=1:length(lowRT)
    for w=1:length(car1)
       if lowRT(1,v)-car1(1,w)>0 && lowRT(1,v)-car1(1,w)<=10
        
           OnTaskhdlabel=horzcat(OnTaskhdlabel,hypot(car1(3,w)-car2(3,w),car1(4,w)-car2(4,w)));
       end
    end
end


for v=1:length(highRT)
    for w=1:length(car1)
       if highRT(1,v)-car1(1,w)>0 && highRT(1,v)-car1(1,w)<=10
        
         MWhdlabel=horzcat(MWhdlabel,hypot(car1(3,w)-car2(3,w),car1(4,w)-car2(4,w)));
       end
    end
end

entireOnTaskhd=vertcat(entireOnTaskhd,mean(OnTaskhdlabel));
entireMWhd=vertcat(entireMWhd,mean(MWhdlabel));

end