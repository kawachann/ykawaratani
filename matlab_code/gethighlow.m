function [BRT1,highRT,lowRT]=gethighlow(car1,car2)

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




%è„à 10%Ç∆â∫à 10%Çî≤Ç´èoÇµ-------------------------------------------------------------------------------

RTcount=length(BRT1(2,:))/10;
RTcount=round(RTcount);

highlabel=maxk(BRT1(2,:),RTcount);
for a=1:length(highlabel)
    for b=1:length(BRT1)
        if a~=length(highlabel)
            if highlabel(a)~= highlabel(a+1)&&highlabel(a)==BRT1(2,b)
            highRT=horzcat(highRT,BRT1(:,b));
            end
        elseif a==length(highlabel)
            if highlabel(a)==BRT1(2,b)
            highRT=horzcat(highRT,BRT1(:,b));
            end
        end      
    end
end

lowlabel=mink(BRT1(2,:),RTcount);
for c=1:length(lowlabel)
    for d=1:length(BRT1)
        if c~=length(lowlabel)
            if lowlabel(c)~=lowlabel(c+1)&&lowlabel(c)==BRT1(2,d)
            lowRT=horzcat(lowRT,BRT1(:,d));
            end
        elseif c==length(lowlabel)
            if lowlabel(c)==BRT1(2,d)
            lowRT=horzcat(lowRT,BRT1(:,d));
            end
        end
    end
end
end
