clear
work_dir = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/log'));
% �ۑ�����t�H���_�̍쐬----------------------------------------------------------------
mkdir(char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/action')));
save_dir = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/action'));
%-----------------------------------------------------------------------------------

subinfo=dir(work_dir);% �팱�҂̖��O
n=length(subinfo);
subN={};%�팱�Җ��̃�k�X�g

% �팱�Җ��̂ݔ����o���ăx�N�g���ɂ���---------------------------
NN=1;
for N=1:n
    if strlength(getfield(subinfo,{N},'name'))==9
        name=cellstr(subinfo(N).name);
         subN(NN)=name;
         NN=NN+1;
    end
end
%--------------------------------------------------------

ontaskave=0;%�S�̂�OnTask���̕��ϊ���
MWave=0;%�S�̂�MW���̕��ϊ���
ontasksum=0;%�S�̂�MW���̍��v�l
MWsum=0;%�S�̂�MW���̍��v�l
entireontask=[];%�e�팱�҂�OnTask�̒����l�i�[
entireMW=[];%�e�팱�҂�MW�̒����l�i�[
avesum=[];%�S�̂�BRT�̍��v�l
avelabel=0;%�S�̂�BT��
entireOnTasksteering=[];%�e�팱�҂�OnTask�̃X�e�A�����O
entireMWsteering=[];%�e�팱�҂�MW�̃X�e�A�����O
entireMWspeed=[];%�e�팱�҂�OnTask�̃X�s�[�h
entireOnTaskspeed=[];%�e�팱�҂�MW�̃X�s�[�h
entireOnTaskstdspeed=[];
entireMWstdspeed=[];
entireOnTaskaccel=[];
entireMWaccel=[];
entireOnTaskhd=[];
entireMWhd=[];
entiremwrate=[];%�S�̂�2�����Ƃ�MW����
entireBRTrate=[];%�S�̂�1�����Ƃ�BRT����
aveBRT=[];%�팱��BRT���ϒl
aveSpeed=[];
aveSteering=[];
stdSpeed=[];
stdAccel=[];
entirelowRT=[];
entirehighRT=[];


%�e�팱�҉��-------------------------------------------------------------------------
for sub=2:length(subN)
%xdf�f�[�^�ϊ�----------------------------------------------------------------------  
subname=subN(sub); % �팱�Җ�

[DS,Presen,DataBox,DataInfo,i,j,SubjectData]= XDFtoMATandTaskDivide(work_dir,subname,save_dir);

log=DS;%�h���C�r���O�V���~���[�^�f�[�^

%��s�ԂƎ��Ԃɕ�����----------------------------------------------------------------

[car1,car2]=getCars(log);

%BRT�Z�o------------------------------------------------------------------

[BRT1,avesum,highRT,lowRT,aveBRT,aveSpeed,aveSteering,stdSpeed,stdAccel,entirehighRT,entirelowRT]=getBRT1(car1,car2,avesum,aveBRT,aveSpeed,aveSteering,stdSpeed,stdAccel,entirehighRT,entirelowRT);

%���n��MW�����C����BRT�Z�o------------------------------------------------------------------
[entiremwrate,entireBRTrate]=corplot(entiremwrate,entireBRTrate,Presen,BRT1);


%�X�e�A�����O�ƃX�s�[�h�ƃA�N�Z���Z�o------------------------------------------------------------------
[entireOnTasksteering,entireMWsteering,entireMWspeed,entireOnTaskspeed,entireOnTaskstdspeed,entireMWstdspeed,entireOnTaskaccel,entireMWaccel,handringresult]=getaction(car1,car2,highRT,lowRT,entireOnTasksteering,entireMWsteering,entireMWspeed,entireOnTaskspeed,entireOnTaskstdspeed,entireMWstdspeed,entireOnTaskaccel,entireMWaccel);

%�Ԋԋ����Z�o------------------------------------------------------------------
[entireOnTaskhd,entireMWhd]=getaction_hd(car1,car2,highRT,lowRT,entireOnTaskhd,entireMWhd)

%�e�팱��BRT�����l�C���ϒl�CMW��OnTask��--------------------------------------------------------
[actionresult,ontasksum,MWsum,entireontask,entireMW] = actiondata(subname,save_dir,Presen,BRT1,ontasksum,MWsum,entireontask,entireMW);

%�f�[�^�ۑ�---------------------------------------------------------------------------------
save_dir2=char(fullfile(save_dir,subname));
save_dir_action=char(fullfile(save_dir,subname));
save(char(fullfile(save_dir2,strcat(subname,'_action.mat'))),'BRT1');%�e�팱��BRT
save(char(fullfile(save_dir_action,strcat(subname,'_BRTaction.mat'))),'actionresult');%���ϒl�Ȃ�
save(char(fullfile(save_dir_action,strcat(subname,'_handring.mat'))),'handringresult');
end

%average=sum(avesum)/length(avesum);
%std=std2(avesum); %�W���΍�
%avelabel=average+std


ontaskave=ontasksum/(sub-1);%�S��OnTask��
MWave=MWsum/(sub-1);%�S��MW��

%MW�̎��n��O���t�\��-------------------------------------------------------------------
x=[2:2:30];
y=mean(entiremwrate);
 xname=char('Time[m]');
 yname=char('MW[%]');
 xrange_vec=[2,4,30];
 yrange_vec=[0,25,100];
 s=18;
 t=90
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);
 

%BRT�̎��n��O���t�\��-------------------------------------------------------------------
 x=[2:2:30];
 y=mean(entireBRTrate);
 xname='Time[m]';
 yname='BRT[s]';
 xrange_vec=[2,4,30];
 yrange_vec=[1,0.3,1.8];
 s=20;
 t=1.7
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);
 

%�e�팟�҂̃X�e�A�����O�W���΍��̕��ϒl��t����C�O���t�\��----------------------------------------
OnTasksteeringave=mean(entireOnTasksteering);
MWsteeringave=mean(entireMWsteering);
%�O��l����
TF1=1;
TF2=1;
for i=1:3
TF1 = find(isoutlier(entireOnTasksteering,'quartiles'));
entireOnTasksteering(TF1)=[];
entireMWsteering(TF1)=[];
TF2 = find(isoutlier(entireMWsteering,'quartiles'));
entireOnTasksteering(TF2)=[];
entireMWsteering(TF2)=[];
if TF1~=[]&TF2~=[]
    break
end
end

% TF1 = isoutlier(entireOnTasksteering,'quartiles');
% TF2 = isoutlier(entireMWsteering,'quartiles');
% 
% for i=1:length(subN)-1
%     if TF1(length(subN)-i)==1||TF2(length(subN)-i)==1
%         entireOnTasksteering(length(subN)-i)=[];
%         entireMWsteering(length(subN)-i)=[];
%     end
% end

%t����
[h1,p1] = ttest(entireOnTasksteering,entireMWsteering);
%figure
%boxplot([entireOnTasksteering entireMWsteering],'labels',{'On Task','MW'});
%ylabel('steering[�x]')


figure
boxplot([entireOnTasksteering entireMWsteering],'labels',{'BRT����10%','BRT���10%'});
ylabel('steering[�x]')
hold on
Y=vertcat(entireOnTasksteering,entireMWsteering);
X=[];
X=horzcat(repelem(1,length(entireOnTasksteering)),repelem(2,length(entireMWsteering)));
X=X';
x = beeswarm(X,Y,'dot_size',3);
hold off


%�e�팟�҂̂̃X�s�[�h�̒����l�̕��ϒl��t����C�O���t�\��----------------------------------------
OnTaskspeedave=mean(entireOnTaskspeed);
MWspeedave=mean(entireMWspeed);
%�O��l����
TF1=1;
TF2=1;
for i=1:3
TF1 = find(isoutlier(entireOnTaskspeed,'quartiles'));
entireOnTaskspeed(TF1)=[];
entireMWspeed(TF1)=[];
TF2 = find(isoutlier(entireMWspeed,'quartiles'));
entireOnTaskspeed(TF2)=[];
entireMWspeed(TF2)=[];
if TF1~=[]&TF2~=[]
    break
end
end

% TF1 = isoutlier(entireOnTaskspeed,'quartiles');
% TF2 = isoutlier(entireMWspeed,'quartiles');
% 
% for i=1:length(subN)-1
%     if TF1(length(subN)-i)==1||TF2(length(subN)-i)==1
%         entireOnTaskspeed(length(subN)-i)=[];
%         entireMWspeed(length(subN)-i)=[];
%     end
% end

%t����
[h2,p2] = ttest(entireOnTaskspeed,entireMWspeed);
%Y=horzcat(entireOnTaskspeed,entireMWspeed);
%[h,L,MX,MED,bw]=violin(Y,'xlabel',{'On Task','MW'},'facecolor',[0.6 0 0;0 0 0.4;]);


figure
boxplot([entireOnTaskspeed entireMWspeed],'labels',{'BRT����10%','BRT���10%'});
ylabel('speed[km/h]')
hold on
Y=vertcat(entireOnTaskspeed,entireMWspeed);
X=[];
X=horzcat(repelem(1,length(entireOnTaskspeed)),repelem(2,length(entireMWspeed)));
X=X';
x = beeswarm(X,Y,'dot_size',3);
hold off
%�e�팟�҂̂̃X�s�[�h�̕W���΍��̕��ϒl��t����C�O���t�\��----------------------------------------
OnTaskstdspeedstdave=mean(entireOnTaskstdspeed);
MWstdspeedstdave=mean(entireMWstdspeed);

%�O��l����
TF1=1;
TF2=1;
for i=1:3
TF1 = find(isoutlier(entireOnTaskstdspeed,'quartiles'));
entireOnTaskstdspeed(TF1)=[];
entireMWstdspeed(TF1)=[];
TF2 = find(isoutlier(entireMWstdspeed,'quartiles'));
entireOnTaskstdspeed(TF2)=[];
entireMWstdspeed(TF2)=[];
if TF1~=[]&TF2~=[]
    break
end
end
% TF1 = isoutlier(entireOnTaskstdspeed,'quartiles');
% TF2 = isoutlier(entireMWstdspeed,'quartiles');
% 
% for i=1:length(subN)-1
%     if TF1(length(subN)-i)==1||TF2(length(subN)-i)==1
%         entireOnTaskstdspeed(length(subN)-i)=[];
%         entireMWstdspeed(length(subN)-i)=[];
%     end
% end

%t����
[h3,p3] = ttest(entireOnTaskstdspeed,entireMWstdspeed);
%Y=horzcat(entireOnTaskspeed,entireMWspeed);
%[h,L,MX,MED,bw]=violin(Y,'xlabel',{'On Task','MW'},'facecolor',[0.6 0 0;0 0 0.4;]);


figure
boxplot([entireOnTaskstdspeed entireMWstdspeed],'labels',{'BRT����10%','BRT���10%'});
ylabel('stdspeed[km/h]')
hold on
Y=vertcat(entireOnTaskstdspeed,entireMWstdspeed);
X=[];
X=horzcat(repelem(1,length(entireOnTaskstdspeed)),repelem(2,length(entireMWstdspeed)));
X=X';
x = beeswarm(X,Y,'dot_size',3);

hold off
%�e�팟�҂̂̃A�N�Z���̕W���΍��̕��ϒl��t����C�O���t�\��----------------------------------------

%�O��l����

TF1=1;
TF2=1;
for i=1:3
TF1 = find(isoutlier(entireOnTaskaccel,'quartiles'));
entireOnTaskaccel(TF1)=[];
entireMWaccel(TF1)=[];
TF2 = find(isoutlier(entireMWaccel,'quartiles'));
entireOnTaskaccel(TF2)=[];
entireMWaccel(TF2)=[];
if TF1~=[]&TF2~=[]
    break
end
end

% TF1 = isoutlier(entireOnTaskaccel,'quartiles');
% TF2 = isoutlier(entireMWaccel,'quartiles');
% 
% for i=1:length(subN)-1
%     if TF1(length(subN)-i)==1||TF2(length(subN)-i)==1
%         entireOnTaskaccel(length(subN)-i)=[];
%         entireMWaccel(length(subN)-i)=[];
%     end
% end


%t����
[h4,p4] = ttest(entireOnTaskaccel,entireMWaccel);
%Y=horzcat(entireOnTaskspeed,entireMWspeed);
%[h,L,MX,MED,bw]=violin(Y,'xlabel',{'On Task','MW'},'facecolor',[0.6 0 0;0 0 0.4;]);


figure
boxplot([entireOnTaskaccel entireMWaccel],'labels',{'BRT����10%','BRT���10%'});
ylabel('Accelerator pedal')
hold on
Y=vertcat(entireOnTaskaccel,entireMWaccel);
X=[];
X=horzcat(repelem(1,length(entireOnTaskaccel)),repelem(2,length(entireMWaccel)));
X=X';
x = beeswarm(X,Y,'dot_size',3);

hold off
%�e�팟�҂̒����l�̕��ϒl��t����O���t�\��-----------------------------------------------
%�O��l����
TF1=1;
TF2=1;
for i=1:3
TF1 = find(isoutlier(entireontask,'quartiles'));
entireontask(TF1)=[];
entireMW(TF1)=[];
TF2 = find(isoutlier(entireMW,'quartiles'));
entireontask(TF2)=[];
entireMW(TF2)=[];
if TF1~=[]&TF2~=[]
    break
end
end

% TF1 = isoutlier(entireontask,'quartiles');
% TF2 = isoutlier(entireMW,'quartiles');
% 
% for i=1:length(subN)-1
%     if TF1(length(subN)-i)==1||TF2(length(subN)-i)==1
%         entireontask(length(subN)-i)=[];
%         entireMW(length(subN)-i)=[];
%     end
% end

%t����
[h5,p5] = ttest(entireontask,entireMW);

figure
boxplot([entireontask entireMW],'labels',{'On Task','MW'});
ylabel('BRT[s]')
hold on
Y=vertcat(entireontask,entireMW);
X=[];
X=horzcat(repelem(1,length(entireontask)),repelem(2,length(entireMW)));
X=X';
x = beeswarm(X,Y,'dot_size',3);
hold off

%�e�팟�҂�highlow10%�̒����l�̕��ϒl��t����O���t�\��----------------------------------------------
%�O��l����
TF1=1;
TF2=1;
for i=1:3
TF1 = find(isoutlier(entirelowRT,'quartiles'));
entirelowRT(TF1)=[];
entirehighRT(TF1)=[];
TF2 = find(isoutlier(entirehighRT,'quartiles'));
entirelowRT(TF2)=[];
entirehighRT(TF2)=[];
if TF1~=[]&TF2~=[]
    break
end
end

% TF1 = isoutlier(entirelowRT,'quartiles');
% TF2 = isoutlier(entirehighRT,'quartiles');
% 
% for i=1:length(subN)-1
%     if TF1(length(subN)-i)==1||TF2(length(subN)-i)==1
%         entirelowRT(length(subN)-i)=[];
%         entirehighRT(length(subN)-i)=[];
%     end
% end
 
%t����
[h6,p6] = ttest(entirelowRT.',entirehighRT.');

figure
boxplot([entirelowRT.' entirehighRT.'],'labels',{'BRT����10%','BRT���10%'});
ylabel('BRT[s]')
hold on
Y=vertcat(entirelowRT.',entirehighRT.');
X=[];
X=horzcat(repelem(1,length(entirelowRT)),repelem(2,length(entirehighRT)));
X=X';
x = beeswarm(X,Y,'dot_size',3);
hold off
%NASA--------------------------------------------------------------------------------
Nasa=[6.9 5.1 4.5 5.3 6.1 7.6 9.3 7 5.75 4.5];
x=Nasa;
y=aveBRT
y=[58 20 41 30 31 65 34 10 31 65];
xname='Nasa';
yname='BRT[s]';
s=8;
t=1.5;
xrange_vec=[1,0.5,10];

yrange_vec=[1,0.2,1.8];
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);
%BRT��speed�O���t�\��-------------------------------------------------------------------
 x=aveBRT;
 y=aveSpeed;
 xname='BRT[s]';
 yname='Speed[s]';
 xrange_vec=[1,0.2,1.8];
 yrange_vec=[69,1,72];
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);
%BRT��stdspeed�O���t�\��-------------------------------------------------------------------
 x=aveBRT;
 y=stdSpeed;
 xname='BRT[s]';
 yname='Speed[s]';
 xrange_vec=[1,0.2,1.8];
 yrange_vec=[5,1,12];
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);

%BRT��steering�O���t�\��-------------------------------------------------------------------
 x=aveBRT;
 y=aveSteering;
 xname='BRT[s]';
 yname='Steering[deg]';
 xrange_vec=[1,0.2,1.8];
 yrange_vec=[5,1,8];
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);

%BRT��aaccel�O���t�\��-------------------------------------------------------------------
 x=aveBRT;
 y=stdAccel;
 xname='BRT[s]';
 yname='Accel';
 xrange_vec=[1,0.2,1.8];
 yrange_vec=[10,10,40];
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);

%�f�[�^�ۑ�---------------------------------------------------------------------------
% mkdir(char(fullfile(save_dir,'result')));
% save_dir3=char(fullfile(save_dir,'result'));
% save(char(fullfile(save_dir3,strcat('result.mat'))),'entireontask','entireMW','p1','p2','p3','MWave','ontaskave','OnTaskspeedave','MWspeedave','OnTasksteeringave','MWsteeringave');

