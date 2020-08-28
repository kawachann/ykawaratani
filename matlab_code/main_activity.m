clear
work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/brain'));
work_pass2=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/log'));


subinfo=dir(work_pass);% �팱�҂̖��O
n=length(subinfo);
subN={};%�팱�Җ��̃�k�X�g

% �팱�Җ��̂ݔ����o���ăx�N�g���ɂ���
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
%nirs�Cxdf�t�@�C�����w��
file_pass_nirs=char(fullfile(work_pass,subname));
mkdir(fullfile(file_pass_nirs,'result'));
save_pass=char(fullfile(file_pass_nirs,'result'));

%nirs�Cxdf�t�@�C���ǂݍ���
raw = nirs.io.loadNIRx(file_pass_nirs);

%od�ϊ��܂�
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

%SSR���s
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

%�x�[�X���C�������Chb�ϊ�
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


%% XDF�t�@�C���ǂݍ���
cd(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/code/xdf-Matlab'));
delete load_xdf_innerloop.mexmaci64
[DS,NIRx,DataBox,DataInfo,SubjectData] = XDFtoMATNIRS(work_pass2,subname);

log=DS;%�h���C�r���O�V���~���[�^�f�[�^

%% ��s�ԂƎ��Ԃɕ�����
[car1,car2]=getCars(log);

%% BRTfast10%��slow10%�����o��
[BRT1,highRT,lowRT,entireRT]=gethighlowNIRS(car1,car2,entireRT);

%% ���֌W���s��쐬�i�����ʑI���Ȃ��j
 [SubNet,MWNIRS,OnTaskNIRS]=getnirsdata(highRT,lowRT,hb,NIRx,save_pass,subname);

%% ���֌W���s���1�����ɂ��A�e�팱�҂�mds��t-SNE�̌��ʕ\���i�����ʑI���Ȃ��j
 [Onelow,save_pass_mds,save_pass_tsne,distancename_mds,distancename_tsne,Loss_group_mds,Loss_group_tsne]=onelow(SubNet,Onelow,lowRT,highRT,subname,Loss_group_mds,Loss_group_tsne);

%% ���֌W���s��쐬�i�����ʑI������j
[SubNet,MWNIRS,OnTaskNIRS]=getnirsdata2(highRT,lowRT,hb,NIRx,save_pass,subname);

%% ���֌W���s���1�����ɂ��A�e�팱�҂�mds��t-SNE�̌��ʕ\���i�����ʑI������j
[Onelow,save_pass_mds,save_pass_tsne,distancename_mds,distancename_tsne,Loss_group_mds,Loss_group_tsne]=onelow2(SubNet,Onelow,lowRT,highRT,subname,Loss_group_mds,Loss_group_tsne);

%% ���֌W���s��̉���
%[count,subcount]=nirsplot2(highRT,lowRT,hb,NIRx,count,subcount)

%% ���֌W���s���z�ϊ�
% [MWNIRS,OnTaskNIRS]=zchange(MWNIRS,OnTaskNIRS);
% 
%% �S�팱�҂̑��֌W���s��ɁiMW,OnTask�j
% EntireMWNIRS=cat(3,EntireMWNIRS,MWNIRS);
% EntireOnTaskNIRS=cat(3,EntireOnTaskNIRS,OnTaskNIRS);
% 
%% �e�팱�҂�highRT��slowRT
% %save(char(fullfile(save_pass,strcat(subname,'highRT.mat'))),'highRT');
% %save(char(fullfile(save_pass,strcat(subname,'lowRT.mat'))),'lowRT');
% 
%% �e�팱�҂�matix
% %save(char(fullfile(save_pass,strcat(subname,'MWdata.mat'))),'MWNIRS');
% %save(char(fullfile(save_pass,strcat(subname,'OnTaskdata.mat'))),'OnTaskNIRS');
% 
 end

%% �S�팱�҂�OnTaskmatrix��MWmatrix������
% NIRSdata=[];
% NIRSdata=cat(3,EntireOnTaskNIRS,EntireMWNIRS);
% %save(char(fullfile(work_pass,'NIRS_10%.mat')),'NIRSdata');
% 
% %% �L�ӂȃ`�����l���Ԍ����\��
% % [happy2]=ttestNIRS(EntireOnTaskNIRS,EntireMWNIRS,subN);
% 
%% mds
 [Coordinates,Coordinates3]=mds(Onelow,distancename_mds,save_pass_mds)
 locationplot(Coordinates,Coordinates3,entireRT,subN,save_pass_mds);
 
%% t-SNE
[Coordinates2,Coordinates4,perplexity2,perplexity4]=Tsne(Onelow,distancename_tsne);
locationplot2(Coordinates2,Coordinates4,entireRT,subN,save_pass_tsne);

