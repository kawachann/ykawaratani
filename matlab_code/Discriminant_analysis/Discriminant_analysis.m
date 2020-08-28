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

mkdir(fullfile(file_pass_nirs,'result_DA'));

save_pass=char(fullfile(file_pass_nirs,'result_DA'));

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

save(char(fullfile(save_pass,strcat('hb.mat'))),'hb');


%% XDFファイル読み込み対応付

cd(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/code/xdf-Matlab-5b27b8cf9577dd903cbfb5386ffbf04c0441eddb'));
delete load_xdf_innerloop.mexmaci64

[DS,NIRx,DataBox,DataInfo,SubjectData] = XDFtoMATNIRS(work_pass2,subname);

log=DS;%ドライビングシュミレータデータ

%% 先行車と自車に分ける
[car1,car2]=getCars(log);

%% BRTfast10%とslow10%抜き出し
[BRT1,highRT,lowRT,entireRT]=gethighlowNIRS(car1,car2,entireRT);

%% 相関係数行列作成（特徴量選択なし）
[SubNet,SubNet_group,Class_group,label1]=getnirsdata_DA(highRT,lowRT,hb,NIRx,SubNet_group,Class_group,label1)

%% 個人間でLDA（特徴量選択なし）
 Loss_sub=LDA_sub(SubNet,lowRT,highRT,Loss_sub)
 
%% 相関係数行列作成（特徴量選択あり）
 [SubNet2,SubNet2_group,Class2_group,label2]=getnirsdata2_DA(highRT,lowRT,hb,NIRx,SubNet2_group,Class2_group,label2)
 
%% 個人間でLDA（特徴量選択あり）
 Loss2_sub=LDA2_sub(SubNet2,lowRT,highRT,Loss2_sub)

end


