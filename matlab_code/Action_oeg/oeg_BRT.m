clear
work_dir = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/OEG_PT/log'));
% �ۑ�����t�H���_�̍쐬----------------------------------------------------------------
mkdir(char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/OEG_PT/action')));
save_dir = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/OEG_PT/action'));
%-----------------------------------------------------------------------------------

subinfo=dir(work_dir);% �팱�҂̖��O
n=length(subinfo);
subN={};%�팱�Җ��̃�k�X�g

% �팱�Җ��̂ݔ����o���ăx�N�g���ɂ���---------------------------
NN=1;
for N=1:n
    if strlength(getfield(subinfo,{N},'name'))==9
        name=cellstr(subinfo(N).name);
         subN(NN)=name;
         NN=NN+1;
    end
end
%--------------------------------------------------------

ontaskave=0;%�S�̂�OnTask���̕��ϊ���
MWave=0;%�S�̂�MW���̕��ϊ���
ontasksum=0;%�S�̂�MW���̍��v�l
MWsum=0;%�S�̂�MW���̍��v�l
entireontask=[];%�e�팱�҂�OnTask�̒����l�i�[
entireMW=[];%�e�팱�҂�MW�̒����l�i�[
avesum=[];%�S�̂�BRT�̍��v�l
avelabel=0;%�S�̂�BT��
entiremwrate=[];%�S�̂�2�����Ƃ�MW����
entireBRTrate=[];%�S�̂�1�����Ƃ�BRT����
aveBRT=[];%�팱��BRT���ϒl


%���Ԃ��S�u���b�N��----
mw1=[];
mw2=[];
mw3=[];
mw4=[];
%-------------------

%�e�팱�҉��-------------------------------------------------------------------------
for sub=2:length(subN)
%xdf�f�[�^�ϊ�----------------------------------------------------------------------  
subname=subN(sub); % �팱�Җ�

[DS,Presen,DataBox,DataInfo,i,j,SubjectData]= XDFtoMATandTaskDivide(work_dir,subname,save_dir);

log=DS;%�h���C�r���O�V���~���[�^�f�[�^

%��s�ԂƎ��Ԃɕ�����----------------------------------------------------------------

[car1,car2]=getCars(log);

%BRT�Z�o------------------------------------------------------------------

[BRT1,avesum]=oeg_getBRT1(car1,car2,avesum,aveBRT);

%���n��MW�����C����BRT�Z�o------------------------------------------------------------------
[mw1,mw2,mw3,mw4]=oeg_corplot(mw1,mw2,mw3,mw4,Presen,BRT1);

%�e�팱��BRT�����l�C���ϒl�CMW��OnTask��--------------------------------------------------------
[actionresult,ontasksum,MWsum,entireontask,entireMW] = actiondata(subname,save_dir,Presen,BRT1,ontasksum,MWsum,entireontask,entireMW);

%�f�[�^�ۑ�---------------------------------------------------------------------------------
save_dir2=char(fullfile(save_dir,subname));
save_dir_action=char(fullfile(save_dir,subname));
save(char(fullfile(save_dir2,strcat(subname,'_action.mat'))),'BRT1');%�e�팱��BRT
save(char(fullfile(save_dir_action,strcat(subname,'_BRTaction.mat'))),'actionresult');%���ϒl�Ȃ�

end
ontaskave=ontasksum/(sub-1);%�S��OnTask��
MWave=MWsum/(sub-1);%�S��MW��

%MW�̎��n��O���t�\��-------------------------------------------------------------------

figure
boxplot([mw1 mw2 mw3 mw4],'labels',{'0-7.5','7.5-15','15-22.5','22.5-30'});
ylabel('mwrate')

%�e�팟�҂̒����l�̕��ϒl��t����O���t�\��-----------------------------------------------

[h4,p4] = ttest(entireontask,entireMW);
%figure
%boxplot([entireontask entireMW],'labels',{'On Task','MW'});
%ylabel('BRT[s]')

figure
boxplot([entireontask entireMW],'labels',{'On Task','MW'});
ylabel('BRT[s]')

%�f�[�^�ۑ�---------------------------------------------------------------------------
mkdir(char(fullfile(save_dir,'result')));
save_dir3=char(fullfile(save_dir,'result'));
save(char(fullfile(save_dir3,strcat('result.mat'))),'entireontask','entireMW','p4','MWave','ontaskave');

