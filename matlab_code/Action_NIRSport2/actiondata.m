function[actionresult,ontasksum,MWsum,entireontask,entireMW] = actiondata(subname,save_dir,Presen,BRT1,ontasksum,MWsum,entireontask,entireMW)

%ProbeTone���ԁC��ϓI�]���CProbeTone�^�X�N�J�n���ԎZ�o-------------------------
ProbeTone=[];
Reaction=[];
onset=[];%�^�X�N�J�n����

for n=1:length(Presen)-1
    if Presen(2,n)==5
        if Presen(2,n+1)==1|Presen(2,n+1)==2
            onset=horzcat(onset,Presen(2,n+1),Presen(1,n));
        ProbeTone=horzcat(ProbeTone,Presen(:,n));
        Reaction=horzcat(Reaction,Presen(:,n+1));
        end
    end
end
save_dir2=char(fullfile(save_dir,subname));
save(char(fullfile(save_dir2,strcat(subname,'_onset.mat'))),'onset');


%ProbeTone10�b�O�Ɋ܂܂��BRT�؂蔲���C�ۑ�------------------------------------
MWcount=0;
ontaskcount=0;
BRT2=[]; 
labelBRT1=[];%BRTtime
labelPresen=[];%ProbeTonetime

BackTime=14
for i=1:length(Reaction)
     if Reaction(2,i)==2
        MWcount=MWcount+1;
        elseif Reaction(2,i)==1
        ontaskcount=ontaskcount+1;
     end
    for j=1:length(BRT1)
        if ProbeTone(1,i)-BRT1(1,j)<BackTime && ProbeTone(1,i)-BRT1(1,j)>0
           
               
               labelPresen=horzcat(labelPresen,Reaction(2,i));
               labelBRT1=horzcat(labelBRT1,BRT1(2,j));
           
        end
    end
end

BRT2=vertcat(BRT2,labelBRT1,labelPresen);
save(char(fullfile(save_dir2,strcat(subname,'_BRT2".mat'))),'BRT2');

%�q�X�g�O����--------------------------------
%x=[];
%y=[];
%for m=1:length(BRT2)
    %if BRT2(2,m)==1
        %x=horzcat(x,BRT2(1,m));
    %else 
       % y=horzcat(y,BRT2(1,m));
    %end
%end

%h1 = histogram(x);
%hold on
%h2 = histogram(y);

%MW,OnTask�d����---------------------------------
MW=[];
ontask=[];

for p=1:length(BRT2)
    if BRT2(2,p)==2
        MW=horzcat(MW,BRT2(1,p));
    else 
        ontask=horzcat(ontask,BRT2(1,p));
    end
end

%�����l�C���ϒl�A�����Z�o--------------------------------
midMW=median(MW);
midontask=median(ontask);
aveMW=mean(MW);
aveontask=mean(ontask);
MWper=MWcount*100/(MWcount+ontaskcount);
ontaskper=ontaskcount*100/(MWcount+ontaskcount);
%save(char(fullfile(save_dir2,strcat(subname,'_mw.mat'))),'MWper');


ontasksum=ontasksum+ontaskper;%�S�̂�OnTask��
MWsum=MWsum+MWper;%�S�̂�MW��
entireontask=vertcat(entireontask,aveontask);%�S�̂�OnTask����BRT�����l
entireMW=vertcat(entireMW,aveMW);%�S�̂�MW����BRT�����l


actionresult=table([midMW;midontask;MWper;ontaskper;aveMW;aveontask],'VariableNames',{'value'},'RowNames',{'MW�����l' 'ontask�����l' 'MW����' 'ontask����' 'MW���ϒl' 'ontask���ϒl'});
save_dir_action=char(fullfile(save_dir,subname));
save(char(fullfile(save_dir_action,strcat(subname,'_BRTaction.mat'))),'actionresult');

end





   

               
  