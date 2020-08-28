clear
work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/brain'));
work_pass2=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/log'));


subinfo=dir(work_pass);% 被験者の名前
n=length(subinfo);
subN={};%被験者名のリkスト

% 被験者名のみ抜き出してベクトルにする
NN=1;
for N=1:n
    if strlength(getfield(subinfo,{N},'name'))==9
        name=cellstr(subinfo(N).name);
         subN(NN)=name;
         NN=NN+1;
    end
end

EntireMWNIRS=[];
EntireOnTaskNIRS=[];
count=0;
subcount=0;
X=[];
Y=[];
ii=1;
Onelow=[];
entireRT=[];
Loss_group_mds=[];
Loss_group_tsne=[];

for i=2:length(subN)
subname=subN(i);
%nirs，xdfファイル名指定
file_pass_nirs=char(fullfile(work_pass,subname));
mkdir(fullfile(file_pass_nirs,'result'));
save_pass=char(fullfile(file_pass_nirs,'result'));

%nirs，xdfファイル読み込み
raw = nirs.io.loadNIRx(file_pass_nirs);

%od変換まで
job1=nirs.modules.ImportData();
job1.Input='raw';
job1=nirs.modules.Assert(job1);
job1.throwerror=true;
job1.condition=@(data)isa(data.probe,'nirs.core.Probe1020');
job1=nirs.modules.RemoveStimless(job1);
job1 = nirs.modules.FixNaNs(job1);
job1 = nirs.modules.OpticalDensity(job1);
% job1 = nirs.modules.BandPassFilter(job1);
% job1.highpass  = 0.01;
% job1.lowpass  = 0.2;
job1 = nirs.modules.ExportData(job1);
job1.Output='OD';
List1 = nirs.modules.pipelineToList(job1);
OD = job1.run(raw);

%SSR実行
blen = 30;
offset = 30;
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

%ベースライン処理，hb変換
job2=nirs.modules.ImportData();
job2.Input='OD_SSR_bp';
% job2 = nirs.modules.TrimBaseline(job2);
% job2.preBaseline   = 30;
% job2.postBaseline  = 30;
%job2 = nirs.modules.BandPassFilter(job2);
%job2.highpass  = 0.01;
%job2.lowpass  = 0.2;
job2= nirs.modules.BeerLambertLaw(job2);
job2 = nirs.modules.ExportData(job2);
job2.Output='hb';
hb = job2.run(OD_SSR_bp);

save(char(fullfile(save_pass,strcat('hb.mat'))),'hb');


%% XDFファイル読み込み
cd(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/code/xdf-Matlab'));
delete load_xdf_innerloop.mexmaci64
[DS,NIRx,DataBox,DataInfo,SubjectData] = XDFtoMATNIRS(work_pass2,subname);

log=DS;%ドライビングシュミレータデータ

%% 先行車と自車に分ける
[car1,car2]=getCars(log);

%% BRTfast10%とslow10%抜き出し
[BRT1,highRT,lowRT,entireRT]=gethighlowNIRS(car1,car2,entireRT);

%% 相関係数行列作成（特徴量選択なし）
 [SubNet,MWNIRS,OnTaskNIRS]=getnirsdata(highRT,lowRT,hb,NIRx,save_pass,subname);

%% 相関係数行列を1次元にし、各被験者のmdsとt-SNEの結果表示（特徴量選択なし）
 [Onelow,save_pass_mds,save_pass_tsne,distancename_mds,distancename_tsne,Loss_group_mds,Loss_group_tsne]=onelow(SubNet,Onelow,lowRT,highRT,subname,Loss_group_mds,Loss_group_tsne);

%% 相関係数行列作成（特徴量選択あり）
[SubNet,MWNIRS,OnTaskNIRS]=getnirsdata2(highRT,lowRT,hb,NIRx,save_pass,subname);

%% 相関係数行列を1次元にし、各被験者のmdsとt-SNEの結果表示（特徴量選択あり）
[Onelow,save_pass_mds,save_pass_tsne,distancename_mds,distancename_tsne,Loss_group_mds,Loss_group_tsne]=onelow2(SubNet,Onelow,lowRT,highRT,subname,Loss_group_mds,Loss_group_tsne);

%% 相関係数行列の可視化
%[count,subcount]=nirsplot2(highRT,lowRT,hb,NIRx,count,subcount)

%% 相関係数行列をz変換
% [MWNIRS,OnTaskNIRS]=zchange(MWNIRS,OnTaskNIRS);
% 
%% 全被験者の相関係数行列に（MW,OnTask）
% EntireMWNIRS=cat(3,EntireMWNIRS,MWNIRS);
% EntireOnTaskNIRS=cat(3,EntireOnTaskNIRS,OnTaskNIRS);
% 
%% 各被験者のhighRTとslowRT
% %save(char(fullfile(save_pass,strcat(subname,'highRT.mat'))),'highRT');
% %save(char(fullfile(save_pass,strcat(subname,'lowRT.mat'))),'lowRT');
% 
%% 各被験者のmatix
% %save(char(fullfile(save_pass,strcat(subname,'MWdata.mat'))),'MWNIRS');
% %save(char(fullfile(save_pass,strcat(subname,'OnTaskdata.mat'))),'OnTaskNIRS');
% 
 end

%% 全被験者のOnTaskmatrixとMWmatrixを合成
% NIRSdata=[];
% NIRSdata=cat(3,EntireOnTaskNIRS,EntireMWNIRS);
% %save(char(fullfile(work_pass,'NIRS_10%.mat')),'NIRSdata');
% 
% %% 有意なチャンネル間結合表示
% % [happy2]=ttestNIRS(EntireOnTaskNIRS,EntireMWNIRS,subN);
% 
%% mds
 [Coordinates,Coordinates3]=mds(Onelow,distancename_mds,save_pass_mds)
 locationplot(Coordinates,Coordinates3,entireRT,subN,save_pass_mds);
 
%% t-SNE
[Coordinates2,Coordinates4,perplexity2,perplexity4]=Tsne(Onelow,distancename_tsne);
locationplot2(Coordinates2,Coordinates4,entireRT,subN,save_pass_tsne);

