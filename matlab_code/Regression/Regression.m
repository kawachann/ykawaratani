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


for i=2:length(subN)
    
subname=subN(i);

%% nirs�t�@�C�����w��
file_pass_nirs=char(fullfile(work_pass,subname));

mkdir(fullfile(file_pass_nirs,'result'));

save_pass=char(fullfile(file_pass_nirs,'result'));

%% nirs�t�@�C���ǂݍ���
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
lowpass=0.01;
highpass=0.001;
fs=OD_SSR_bp.Fs;
bp = nirs.realtime.BandPass(lowpass,highpass,fs);
data_OD_SSR_bp = update(bp,OD_SSR_bp.data,OD_SSR_bp.time);
OD_SSR_bp.data = data_OD_SSR_bp ;

%hb�ϊ�
job2=nirs.modules.ImportData();
job2.Input='OD_SSR_bp';
job2= nirs.modules.BeerLambertLaw(job2);
job2 = nirs.modules.ExportData(job2);
job2.Output='hb';
hb = job2.run(OD_SSR_bp);

%% XDF�t�@�C���ǂݍ���
cd(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/code/xdf-Matlab-5b27b8cf9577dd903cbfb5386ffbf04c0441eddb'));
delete load_xdf_innerloop.mexmaci64

[DS,NIRx,DataBox,DataInfo,SubjectData] = XDFtoMATNIRS(work_pass2,subname);

log=DS;%�h���C�r���O�V���~���[�^�f�[�^

%% ��s�ԂƎ��Ԃɕ�����------------------------------------------------------
[car1,car2]=getCars(log);

%% object_variable_use�����o���i�ړI�֐��j-----------------------------------
[objective_variable_use,BRT1]=get_objective_variable_use(car1,car2);

%% planatory_variable_1_use�����o���i�����ϐ��j------------------------------
[explanatory_variable_1_use]=get_explanatory_variable_1_use(hb,NIRx,BRT1);

%% object_variable_use�Aplanatory_variable_1_use�ۑ�
save_dir2=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Regression_DIL/Mydata'));

mkdir(char(fullfile(save_dir2,subname)));

save(char(fullfile(save_dir2,subname,strcat(subname,'_BRT0.3-3.mat'))),'objective_variable_use','explanatory_variable_1_use');

end