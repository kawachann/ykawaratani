function [DS,NIRx,DataBox,DataInfo,SubjectData] = XDFtoMATNIRS(work_pass2,subname)

cd(char(fullfile(work_pass2,subname)))

cd(char(fullfile(work_pass2,subname)))
files = dir('*.xdf'); % reading all data with .xdf format

fid = files.name;

SubjectData=load_xdf(fid);

for i=1:length(SubjectData)

    DataBox=SubjectData(i);
    DataInfo=DataBox{1}.info;

    %�v���[���e�[�V�����f�[�^�̕ϐ��ݒ�i���g��char�^�̃Z���z��Ȃ��߁Cdouble�ɕύX�j-------
    if string(DataInfo.name)=='Presentation'
        PrTime=DataBox{1}.time_stamps;
        PrTime=PrTime-PrTime(1);
        Zerolabel=DataBox{1}.time_stamps;
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

    %NIRS�f�[�^�̕ϐ��ݒ�-------------------
    if string(DataInfo.type)=='NIRS'
        NirsTime=DataBox{1}.time_stamps;
        NirsTime=NirsTime-Zerolabel(1);
       NirsData2=DataBox{1}.time_series;
        a1=find(NirsTime<0);
       NirsData=NirsData2.';
      

    %DS�f�[�^�̕ϐ��ݒ�---------------------
    elseif string(DataInfo.type)=='car'
        DsTime=DataBox{1}.time_stamps
        DsTime=DsTime-Zerolabel(1);
         a2=find(DsTime<0);
        DsLog=DataBox{1}.time_series;
    end
end

TaskTime=1800;%��������

%�������Ԉȍ~�؂���-------------------
DsLog(1,:)=DsTime;
DsEnd=knnsearch(DsTime',TaskTime);
DS=DsLog(:,1:DsEnd);
DS(:,a2)=[];

%����-------------------
NIRx=vertcat(NirsTime,NirsData2);
NIRx(:,a1)=[];
end