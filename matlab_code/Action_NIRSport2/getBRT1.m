function [BRT1,avesum,highRT,lowRT,aveBRT,aveSpeed,aveSteering,stdSpeed,stdAccel,entirehighRT,entirelowRT]=getBRT1(car1,car2,avesum,aveBRT,aveSpeed,aveSteering,stdSpeed,stdAccel,entirehighRT,entirelowRT);


%brake task�Ɋ֌W�Ȃ�driving car��brake�r��-----------------------------
brake1=car1(8,:); %driving car��brake time
brake2=car2(8,:); %leading car��brake time

brakelabel1=[];
brakelabel2=[];

highRT=[];%��ʂP�O��
highlabel=[];
lowRT=[];%���ʂP�O��
lowlabel=[];
    
%braketime�i�[
for m=2:length(brake2)
    if brake1(m-1)==0 && brake1(m)>0
        
        brakelabel1=horzcat(brakelabel1,car1(1,m));
        
    elseif brake2(m-1)==0 && brake2(m)>0
        
        brakelabel2=horzcat(brakelabel2,car2(1,m));
       
    end
end                                 

%BRT���Z�o---------------------------------------------------------------------------------
BT1=[];
BT2=[];
RT=[];
for s=1:length(brakelabel2)
    for t=1:length(brakelabel1)
        if brakelabel1(t)-brakelabel2(s)<3 && 0.3<brakelabel1(t)-brakelabel2(s)
            BT1=horzcat(BT1,brakelabel1(t));
            BT2=horzcat(BT2,brakelabel2(s));
            RT=horzcat(RT,brakelabel1(t)-brakelabel2(s));
            break
        end 
    end
end
BRT1=vertcat(BT2,RT);%brake reaction time




%���10%�Ɖ���10%�𔲂��o��-------------------------------------------------------------------------------

RTcount=length(BRT1(2,:))/10;
RTcount=round(RTcount);

highlabel=horzcat(highlabel,maxk(BRT1(2,:),RTcount));
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

lowlabel=horzcat(lowlabel,mink(BRT1(2,:),RTcount));
for a=1:length(lowlabel)
    for b=1:length(BRT1)
        if a~=length(lowlabel)
            if lowlabel(a)~= lowlabel(a+1)&&lowlabel(a)==BRT1(2,b)
            lowRT=horzcat(lowRT,BRT1(:,b));
            end
        elseif a==length(lowlabel)
            if lowlabel(a)==BRT1(2,b)
            lowRT=horzcat(lowRT,BRT1(:,b));
            end
        end
    end
end

entirehighRT=horzcat(entirehighRT,mean(highRT(2,:)));
entirelowRT=horzcat(entirelowRT,mean(lowRT(2,:)));
%�S�̂̕��σX�e�A�����O�A�ԑ��𔲂��o��-------------------------------------------------------------------------------
labelSpeed=[];
labelSteering=[];
labelAccel=[];
for n=1:length(BRT1)-1
 for m=1:length(car1)
    if BRT1(1,n)+4<car1(1,m)&&BRT1(1,n+1)>car1(1,m)
   %if BRT1(1,n)-car1(1,m)<10&&BRT1(1,n+1)-car1(1,m)>0
        labelSpeed=horzcat(labelSpeed,car1(5,m));
        labelSteering=horzcat(labelSteering,car1(6,m));
        labelAccel=horzcat(labelAccel,car1(7,m));
    end
 end
end


aveSpeed=horzcat(aveSpeed,mean(labelSpeed));
stdSpeed=horzcat(stdSpeed,std(labelSpeed));
aveSteering=horzcat(aveSteering,std(labelSteering*1800/pi));
stdAccel=horzcat(stdAccel,std(labelAccel*100));
aveBRT=horzcat(aveBRT,mean(BRT1(2,:)));
avesum=horzcat(avesum,BRT1(2,:));%�S�̂�BRT���v�l
end
