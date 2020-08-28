function [object_variable_use,BRT1]=get_object_variable_use(car1,car2)
object_variable_use=[];
%brake taskÇ…ä÷åWÇ»Ç¢driving carÇÃbrakeîrèú-----------------------------
brake1=car1(8,:); %driving carÇÃbrake time
brake2=car2(8,:); %leading carÇÃbrake time

brakelabel1=[];
brakelabel2=[];

highRT=[];%è„à ÇPÇOÅì
highlabel=[];
lowRT=[];%â∫à ÇPÇOÅì
lowlabel=[];
    
%braketimeäiî[
for m=2:length(brake2)
    if brake1(m-1)==0 && brake1(m)>0
        
        brakelabel1=horzcat(brakelabel1,car1(1,m));
        
    elseif brake2(m-1)==0 && brake2(m)>0
        
        brakelabel2=horzcat(brakelabel2,car2(1,m));
       
    end
end                                 

%BRTÇéZèo---------------------------------------------------------------------------------
BT=[];
RT=[];
for s=1:length(brakelabel2)
    for t=1:length(brakelabel1)
        if brakelabel1(t)-brakelabel2(s)<4 && 0<brakelabel1(t)-brakelabel2(s)
            
            BT=horzcat(BT,brakelabel2(s));
            RT=horzcat(RT,brakelabel1(t)-brakelabel2(s));
            break
        end 
    end
end
BRT1=vertcat(BT,RT);%brake reaction time
object_variable_use=BRT1(2,:)';


