clear
work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/brain'));
work_pass2=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/log'));

%% 被験者名のみ抜き出してベクトルにする

subinfo=dir(work_pass);% 被験者の名前
n=length(subinfo);
subN={};%被験者名のリkスト
NN=1;

for N=1:n
    if strlength(getfield(subinfo,{N},'name'))==9
        name=cellstr(subinfo(N).name);
         subN(NN)=name;
         NN=NN+1;
    end
end

%% 変数作成
Onelow=[];
entireRT=[];
Loss_sub=[];
Loss2_sub=[];
label1=1;
label2=1;
SubNet_group=[];
SubNet2_group=[];
Class_group=[];
Class2_group=[];


for i=2:length(subN)
    
subname=subN(i);

%% nirsファイル名指定、結果ファイル作成

file_pass_nirs=char(fullfile(work_pass,subname));

%% nirsファイル読み込み

raw = nirs.io.loadNIRx(file_pass_nirs);

%od変換まで
job1=nirs.modules.ImportData();
job1.Input='raw';
% job1=nirs.modules.Assert(job1);
% job1.throwerror=true;
% job1.condition=@(data)isa(data.probe,'nirs.core.Probe1020');
job1=nirs.modules.RemoveStimless(job1);
job1 = nirs.modules.FixNaNs(job1);
job1 = nirs.modules.OpticalDensity(job1);
job1 = nirs.modules.ExportData(job1);
job1.Output='OD';
List1 = nirs.modules.pipelineToList(job1);
OD = job1.run(raw);

%SSR実行
blen = 5;
offset = 10;
task = 0;
thres = 21;
OD_SSR = nirs.modules.ntbxSSR(OD, blen, offset, task, thres);

OD_SSR_bp = OD_SSR;
lowpass=0.1;
highpass=0.01;
fs=OD_SSR_bp.Fs;
bp = nirs.realtime.BandPass(lowpass,highpass,fs);
data_OD_SSR_bp = update(bp,OD_SSR_bp.data,OD_SSR_bp.time);
OD_SSR_bp.data = data_OD_SSR_bp ;

%hb変換
job2=nirs.modules.ImportData();
job2.Input='OD_SSR_bp';
job2= nirs.modules.BeerLambertLaw(job2);
job2 = nirs.modules.ExportData(job2);
job2.Output='hb';
hb = job2.run(OD_SSR_bp);



%% XDFファイル読み込み対応付

cd(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/code/xdf-Matlab'));
delete load_xdf_innerloop.mexmaci64

[DS,NIRx,DataBox,DataInfo,SubjectData] = XDFtoMATNIRS(work_pass2,subname);

log=DS;%ドライビングシュミレータデータ

%% 先行車と自車に分ける
[car1,car2]=getCars(log);

%% BRTfast10%とslow10%抜き出し
[BRT1,highRT,lowRT,entireRT]=gethighlowNIRS(car1,car2,entireRT);

%% 相関係数行列作成（特徴量選択なし）
[SubNet,SubNet_group,Class_group,label1]=getnirsdata_DA(highRT,lowRT,hb,NIRx,SubNet_group,Class_group,label1);
 
%% グループ間の相関係数行列作成（特徴量選択あり）
% Feature_name_group='DAN'
% [SubNet2,SubNet2_group,Class2_group,label2]=getnirsdata2_DA(highRT,lowRT,hb,NIRx,SubNet2_group,Class2_group,label2,Feature_name_group);
  
%%  個人のInput_variable,class作成（特徴量選択なし）
%get_input_variable_class_sub_Nonfeatureselection(SubNet,lowRT,highRT,subname);
 
%% 個人間の相関係数行列作成（特徴量選択あり） 
%Feature_name_sub='DAN'
%SubNet2=getnirsdata2_DA_sub(highRT,lowRT,hb,NIRx,file_pass_nirs,subname,Feature_name_sub)
 
%% 個人のInput_variable,class作成（特徴量選択あり）
%get_input_variable_class_sub_featureselection(SubNet2,lowRT,highRT,subname,Feature_name_sub);
 
%% 個人のInput_variable,class作成（逐次特徴選択）
%LDA_QDA='LDA';
%get_input_variable_class_sub_featureselection_sequentialfs(SubNet,lowRT,highRT,subname,LDA_QDA)
end

%% グループのloo用のInput_variable,class作成（特徴量選択なし）
%get_input_variable_class_loo_group_Nonfeatureslection(SubNet_group,Class_group)

%% グループのloo用のInput_variable,class作成（特徴量選択あり）
%get_input_variable_class_loo_group_featureslection(SubNet2_group,Class2_group,Feature_name_group)

%% グループのloso用のInput_variable,class作成（特徴量選択なし）
%get_input_variable_class_loso_group_Nonfeatureslection(SubNet_group,Class_group)

%% グループのloso用のInput_variable,class作成（特徴量選択あり）
%get_input_variable_class_loso_group_featureslection(SubNet2_group,Class2_group,Feature_name_group)

%% グループのloo用のInput_variable,class作成（逐次特徴選択）
 LDA_QDA='QDA'
 get_input_variable_class_loo_group_featureselection_sequentialfs(SubNet_group,Class_group,LDA_QDA)

%% グループのloso用のInput_variable,class作成（逐次特徴選択）
 %LDA_QDA='QDA'
 %get_input_variable_class_loso_group_featureselection_sequentialfs(SubNet_group,Class_group,LDA_QDA)
 
%% グループのloso用のInput_variable,class作成（日和先生逐次特徴選択）
% LDA_QDA='LDA'
% selection_number=4;
% get_input_variable_class_loo_group2_featureselection_sequentialfs(SubNet_group,Class_group,LDA_QDA,selection_number)