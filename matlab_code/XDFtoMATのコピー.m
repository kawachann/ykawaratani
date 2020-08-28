clear

%�팱�Ҕԍ�
SubNo='4';

%xdf���݃t�@�C���̑��΃p�X
filepath='../data/xdf/';

%mat�t�@�C���ۑ���̑��΃p�X
savepath='../data/mat/';

xdf_file=horzcat(filepath,'subject',SubNo,'.xdf');
SubjectData=load_xdf(xdf_file);

for i=1:length(SubjectData)

    DataBox=SubjectData(i);
    DataInfo=DataBox{1}.info;

    %ECG�f�[�^�̕ϐ��ݒ�
    if string(DataInfo.type)=='EEG'
        EcgTime=DataBox{1}.time_stamps;
        EcgTime=EcgTime-EcgTime(1);
        EcgAmp=DataBox{1}.time_series;

    %DS�f�[�^�̕ϐ��ݒ�
    elseif string(DataInfo.type)=='car'
        DsTime=DataBox{1}.time_stamps;
        DsTime=DsTime-DsTime(1);
        DsLog=DataBox{1}.time_series;

    %�v���[���e�[�V�����f�[�^�̕ϐ��ݒ�i���g��char�^�̃Z���z��Ȃ��߁Cdouble�ɕύX�j
    elseif string(DataInfo.name)=='Presentation'
        PrTime=DataBox{1}.time_stamps;
        PrTime=PrTime-PrTime(1);
        PrLog=DataBox{1}.time_series;
        for j=1:length(PrLog)
            PrLog{j}=str2double(PrLog{j});
        end
        PrLog=cell2mat(PrLog);
    end

end

TaskTime=1800;

EcgEnd=knnsearch(EcgTime',TaskTime);
ECG=vertcat(EcgTime(1:EcgEnd),EcgAmp(1:EcgEnd));

DsLog(1,:)=DsTime;
DsEnd=knnsearch(DsTime',TaskTime);
DS=DsLog(:,1:DsEnd);

Presen=vertcat(PrTime,PrLog);

save(horzcat(savepath,'Subject',SubNo,'.mat'),'ECG','DS','Presen')