function [object_variable_use,BRT1]=get_object_variable_use(car1,car2)
object_variable_use=[];
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


