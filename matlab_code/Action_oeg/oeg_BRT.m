clear
work_dir = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/OEG_PT/log'));
% 保存するフォルダの作成----------------------------------------------------------------
mkdir(char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/OEG_PT/action')));
save_dir = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/OEG_PT/action'));
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
entiremwrate=[];%全体の2分ごとのMW割合
entireBRTrate=[];%全体の1分ごとのBRT割合
aveBRT=[];%被験者BRT平均値


%時間を４ブロックに----
mw1=[];
mw2=[];
mw3=[];
mw4=[];
%-------------------

%各被験者解析-------------------------------------------------------------------------
for sub=2:length(subN)
%xdfデータ変換----------------------------------------------------------------------  
subname=subN(sub); % 被験者名

[DS,Presen,DataBox,DataInfo,i,j,SubjectData]= XDFtoMATandTaskDivide(work_dir,subname,save_dir);

log=DS;%ドライビングシュミレータデータ

%先行車と自車に分ける----------------------------------------------------------------

[car1,car2]=getCars(log);

%BRT算出------------------------------------------------------------------

[BRT1,avesum]=oeg_getBRT1(car1,car2,avesum,aveBRT);

%時系列MW割合，平均BRT算出------------------------------------------------------------------
[mw1,mw2,mw3,mw4]=oeg_corplot(mw1,mw2,mw3,mw4,Presen,BRT1);

%各被験者BRT中央値，平均値，MWとOnTask率--------------------------------------------------------
[actionresult,ontasksum,MWsum,entireontask,entireMW] = actiondata(subname,save_dir,Presen,BRT1,ontasksum,MWsum,entireontask,entireMW);

%データ保存---------------------------------------------------------------------------------
save_dir2=char(fullfile(save_dir,subname));
save_dir_action=char(fullfile(save_dir,subname));
save(char(fullfile(save_dir2,strcat(subname,'_action.mat'))),'BRT1');%各被験者BRT
save(char(fullfile(save_dir_action,strcat(subname,'_BRTaction.mat'))),'actionresult');%平均値など

end
ontaskave=ontasksum/(sub-1);%全体OnTask率
MWave=MWsum/(sub-1);%全体MW率

%MWの時系列グラフ表示-------------------------------------------------------------------

figure
boxplot([mw1 mw2 mw3 mw4],'labels',{'0-7.5','7.5-15','15-22.5','22.5-30'});
ylabel('mwrate')

%各被検者の中央値の平均値でt検定グラフ表示-----------------------------------------------

[h4,p4] = ttest(entireontask,entireMW);
%figure
%boxplot([entireontask entireMW],'labels',{'On Task','MW'});
%ylabel('BRT[s]')

figure
boxplot([entireontask entireMW],'labels',{'On Task','MW'});
ylabel('BRT[s]')

%データ保存---------------------------------------------------------------------------
mkdir(char(fullfile(save_dir,'result')));
save_dir3=char(fullfile(save_dir,'result'));
save(char(fullfile(save_dir3,strcat('result.mat'))),'entireontask','entireMW','p4','MWave','ontaskave');

