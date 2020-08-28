clear
work_dir = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/log'));
% 保存するフォルダの作成----------------------------------------------------------------
mkdir(char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/action')));
save_dir = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/action'));
%-----------------------------------------------------------------------------------

subinfo=dir(work_dir);% 被験者の名前
n=length(subinfo);
subN={};%被験者名のリkスト

% 被験者名のみ抜き出してベクトルにする---------------------------
NN=1;
for N=1:n
    if strlength(getfield(subinfo,{N},'name'))==9
        name=cellstr(subinfo(N).name);
         subN(NN)=name;
         NN=NN+1;
    end
end
%--------------------------------------------------------

ontaskave=0;%全体のOnTask率の平均割合
MWave=0;%全体のMW率の平均割合
ontasksum=0;%全体のMW率の合計値
MWsum=0;%全体のMW率の合計値
entireontask=[];%各被験者のOnTaskの中央値格納
entireMW=[];%各被験者のMWの中央値格納
avesum=[];%全体のBRTの合計値
avelabel=0;%全体のBT回数
entireOnTasksteering=[];%各被験者のOnTaskのステアリング
entireMWsteering=[];%各被験者のMWのステアリング
entireMWspeed=[];%各被験者のOnTaskのスピード
entireOnTaskspeed=[];%各被験者のMWのスピード
entireOnTaskstdspeed=[];
entireMWstdspeed=[];
entireOnTaskaccel=[];
entireMWaccel=[];
entireOnTaskhd=[];
entireMWhd=[];
entiremwrate=[];%全体の2分ごとのMW割合
entireBRTrate=[];%全体の1分ごとのBRT割合
aveBRT=[];%被験者BRT平均値
aveSpeed=[];
aveSteering=[];
stdSpeed=[];
stdAccel=[];
entirelowRT=[];
entirehighRT=[];


%各被験者解析-------------------------------------------------------------------------
for sub=2:length(subN)
%xdfデータ変換----------------------------------------------------------------------  
subname=subN(sub); % 被験者名

[DS,Presen,DataBox,DataInfo,i,j,SubjectData]= XDFtoMATandTaskDivide(work_dir,subname,save_dir);

log=DS;%ドライビングシュミレータデータ

%先行車と自車に分ける----------------------------------------------------------------

[car1,car2]=getCars(log);

%BRT算出------------------------------------------------------------------

[BRT1,avesum,highRT,lowRT,aveBRT,aveSpeed,aveSteering,stdSpeed,stdAccel,entirehighRT,entirelowRT]=getBRT1(car1,car2,avesum,aveBRT,aveSpeed,aveSteering,stdSpeed,stdAccel,entirehighRT,entirelowRT);

%時系列MW割合，平均BRT算出------------------------------------------------------------------
[entiremwrate,entireBRTrate]=corplot(entiremwrate,entireBRTrate,Presen,BRT1);


%ステアリングとスピードとアクセル算出------------------------------------------------------------------
[entireOnTasksteering,entireMWsteering,entireMWspeed,entireOnTaskspeed,entireOnTaskstdspeed,entireMWstdspeed,entireOnTaskaccel,entireMWaccel,handringresult]=getaction(car1,car2,highRT,lowRT,entireOnTasksteering,entireMWsteering,entireMWspeed,entireOnTaskspeed,entireOnTaskstdspeed,entireMWstdspeed,entireOnTaskaccel,entireMWaccel);

%車間距離算出------------------------------------------------------------------
[entireOnTaskhd,entireMWhd]=getaction_hd(car1,car2,highRT,lowRT,entireOnTaskhd,entireMWhd)

%各被験者BRT中央値，平均値，MWとOnTask率--------------------------------------------------------
[actionresult,ontasksum,MWsum,entireontask,entireMW] = actiondata(subname,save_dir,Presen,BRT1,ontasksum,MWsum,entireontask,entireMW);

%データ保存---------------------------------------------------------------------------------
save_dir2=char(fullfile(save_dir,subname));
save_dir_action=char(fullfile(save_dir,subname));
save(char(fullfile(save_dir2,strcat(subname,'_action.mat'))),'BRT1');%各被験者BRT
save(char(fullfile(save_dir_action,strcat(subname,'_BRTaction.mat'))),'actionresult');%平均値など
save(char(fullfile(save_dir_action,strcat(subname,'_handring.mat'))),'handringresult');
end

%average=sum(avesum)/length(avesum);
%std=std2(avesum); %標準偏差
%avelabel=average+std


ontaskave=ontasksum/(sub-1);%全体OnTask率
MWave=MWsum/(sub-1);%全体MW率

%MWの時系列グラフ表示-------------------------------------------------------------------
x=[2:2:30];
y=mean(entiremwrate);
 xname=char('Time[m]');
 yname=char('MW[%]');
 xrange_vec=[2,4,30];
 yrange_vec=[0,25,100];
 s=18;
 t=90
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);
 

%BRTの時系列グラフ表示-------------------------------------------------------------------
 x=[2:2:30];
 y=mean(entireBRTrate);
 xname='Time[m]';
 yname='BRT[s]';
 xrange_vec=[2,4,30];
 yrange_vec=[1,0.3,1.8];
 s=20;
 t=1.7
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);
 

%各被検者のステアリング標準偏差の平均値でt検定，グラフ表示----------------------------------------
OnTasksteeringave=mean(entireOnTasksteering);
MWsteeringave=mean(entireMWsteering);
%外れ値除去
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

%t検定
[h1,p1] = ttest(entireOnTasksteering,entireMWsteering);
%figure
%boxplot([entireOnTasksteering entireMWsteering],'labels',{'On Task','MW'});
%ylabel('steering[度]')


figure
boxplot([entireOnTasksteering entireMWsteering],'labels',{'BRT下位10%','BRT上位10%'});
ylabel('steering[度]')
hold on
Y=vertcat(entireOnTasksteering,entireMWsteering);
X=[];
X=horzcat(repelem(1,length(entireOnTasksteering)),repelem(2,length(entireMWsteering)));
X=X';
x = beeswarm(X,Y,'dot_size',3);
hold off


%各被検者ののスピードの中央値の平均値でt検定，グラフ表示----------------------------------------
OnTaskspeedave=mean(entireOnTaskspeed);
MWspeedave=mean(entireMWspeed);
%外れ値除去
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

%t検定
[h2,p2] = ttest(entireOnTaskspeed,entireMWspeed);
%Y=horzcat(entireOnTaskspeed,entireMWspeed);
%[h,L,MX,MED,bw]=violin(Y,'xlabel',{'On Task','MW'},'facecolor',[0.6 0 0;0 0 0.4;]);


figure
boxplot([entireOnTaskspeed entireMWspeed],'labels',{'BRT下位10%','BRT上位10%'});
ylabel('speed[km/h]')
hold on
Y=vertcat(entireOnTaskspeed,entireMWspeed);
X=[];
X=horzcat(repelem(1,length(entireOnTaskspeed)),repelem(2,length(entireMWspeed)));
X=X';
x = beeswarm(X,Y,'dot_size',3);
hold off
%各被検者ののスピードの標準偏差の平均値でt検定，グラフ表示----------------------------------------
OnTaskstdspeedstdave=mean(entireOnTaskstdspeed);
MWstdspeedstdave=mean(entireMWstdspeed);

%外れ値除去
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

%t検定
[h3,p3] = ttest(entireOnTaskstdspeed,entireMWstdspeed);
%Y=horzcat(entireOnTaskspeed,entireMWspeed);
%[h,L,MX,MED,bw]=violin(Y,'xlabel',{'On Task','MW'},'facecolor',[0.6 0 0;0 0 0.4;]);


figure
boxplot([entireOnTaskstdspeed entireMWstdspeed],'labels',{'BRT下位10%','BRT上位10%'});
ylabel('stdspeed[km/h]')
hold on
Y=vertcat(entireOnTaskstdspeed,entireMWstdspeed);
X=[];
X=horzcat(repelem(1,length(entireOnTaskstdspeed)),repelem(2,length(entireMWstdspeed)));
X=X';
x = beeswarm(X,Y,'dot_size',3);

hold off
%各被検者ののアクセルの標準偏差の平均値でt検定，グラフ表示----------------------------------------

%外れ値除去

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


%t検定
[h4,p4] = ttest(entireOnTaskaccel,entireMWaccel);
%Y=horzcat(entireOnTaskspeed,entireMWspeed);
%[h,L,MX,MED,bw]=violin(Y,'xlabel',{'On Task','MW'},'facecolor',[0.6 0 0;0 0 0.4;]);


figure
boxplot([entireOnTaskaccel entireMWaccel],'labels',{'BRT下位10%','BRT上位10%'});
ylabel('Accelerator pedal')
hold on
Y=vertcat(entireOnTaskaccel,entireMWaccel);
X=[];
X=horzcat(repelem(1,length(entireOnTaskaccel)),repelem(2,length(entireMWaccel)));
X=X';
x = beeswarm(X,Y,'dot_size',3);

hold off
%各被検者の中央値の平均値でt検定グラフ表示-----------------------------------------------
%外れ値除去
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

%t検定
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

%各被検者のhighlow10%の中央値の平均値でt検定グラフ表示----------------------------------------------
%外れ値除去
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
 
%t検定
[h6,p6] = ttest(entirelowRT.',entirehighRT.');

figure
boxplot([entirelowRT.' entirehighRT.'],'labels',{'BRT下位10%','BRT上位10%'});
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
%BRTとspeedグラフ表示-------------------------------------------------------------------
 x=aveBRT;
 y=aveSpeed;
 xname='BRT[s]';
 yname='Speed[s]';
 xrange_vec=[1,0.2,1.8];
 yrange_vec=[69,1,72];
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);
%BRTとstdspeedグラフ表示-------------------------------------------------------------------
 x=aveBRT;
 y=stdSpeed;
 xname='BRT[s]';
 yname='Speed[s]';
 xrange_vec=[1,0.2,1.8];
 yrange_vec=[5,1,12];
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);

%BRTとsteeringグラフ表示-------------------------------------------------------------------
 x=aveBRT;
 y=aveSteering;
 xname='BRT[s]';
 yname='Steering[deg]';
 xrange_vec=[1,0.2,1.8];
 yrange_vec=[5,1,8];
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);

%BRTとaaccelグラフ表示-------------------------------------------------------------------
 x=aveBRT;
 y=stdAccel;
 xname='BRT[s]';
 yname='Accel';
 xrange_vec=[1,0.2,1.8];
 yrange_vec=[10,10,40];
[f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t);

%データ保存---------------------------------------------------------------------------
% mkdir(char(fullfile(save_dir,'result')));
% save_dir3=char(fullfile(save_dir,'result'));
% save(char(fullfile(save_dir3,strcat('result.mat'))),'entireontask','entireMW','p1','p2','p3','MWave','ontaskave','OnTaskspeedave','MWspeedave','OnTasksteeringave','MWsteeringave');

