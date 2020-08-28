function [DS,Presen,DataBox,DataInfo,i,j,SubjectData] = XDFtoMATandTaskDivide(work_dir,subname,save_dir)

cd(char(fullfile(work_dir,subname)))

cd(char(fullfile(work_dir,subname)))
files = dir('*.xdf'); % reading all data with .xdf format

fid = files.name;

SubjectData=load_xdf(fid);

for i=1:length(SubjectData)

    DataBox=SubjectData(i);
    DataInfo=DataBox{1}.info;

    %プレゼンテーションデータの変数設定（中身がchar型のセル配列なため，doubleに変更）-------
    if string(DataInfo.name)=='Presentation'
        PrTime=DataBox{1}.time_stamps;
        Zerolabel=DataBox{1}.time_stamps;
        PrTime=PrTime-PrTime(1);
        PrLog=DataBox{1}.time_series;
        for j=1:length(PrLog)
            PrLog{j}=str2double(PrLog{j});
        end
        PrLog=cell2mat(PrLog);
    end

end
for i=1:length(SubjectData)
     DataBox=SubjectData(i);
    DataInfo=DataBox{1}.info;

    %NIRSデータの変数設定-------------------
    %if string(DataInfo.type)=='NIRS'
        %NirsTime=DataBox{1}.time_stamps;
        %NirsTime=NirsTime-NirsTime(1);
       %NirsData2=DataBox{1}.time_series;
       %NirsData=NirsData2.';
      

    %DSデータの変数設定---------------------
    if string(DataInfo.type)=='car'
        DsTime=DataBox{1}.time_stamps
        %DsTime=DsTime-DsTime(1);
        DsTime=DsTime-Zerolabel(1);
        a=find(DsTime<0)
        DsLog=DataBox{1}.time_series;
    end
end

TaskTime=1800;%実験時間

%実験時間以降切り取り-------------------
DsLog(1,:)=DsTime;
DsEnd=knnsearch(DsTime',TaskTime);
DS=DsLog(:,1:DsEnd);
DS(:,a)=[];


Presen=vertcat(PrTime,PrLog);%Presenデータ合成
%保存フォルダ作成---------------------------------------------------------------------------------
mkdir(char( fullfile(save_dir,subname)));
%mkdir(char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/brain',subname)));
%save_dir_nirs = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/brain',subname));
save_dir_action=char(fullfile(save_dir,subname));
%Presen Nirs,Dsデータ保存---------------------------------------------------------------------------------
save(char(fullfile(save_dir_action,strcat(subname,'_lowaction.mat'))),'Presen','DS');
%xlswrite(char(fullfile(save_dir_nirs,strcat(subname,'_oeg.xlsx'))),NirsData);
%xlswrite(char(fullfile(save_dir_nirs,strcat(subname,'_oegtime.xlsx'))),NirsTime); 
            
end

