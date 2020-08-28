clear
%% ���̓f�[�^
LDA_QDA='QDA'

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Non_featureslection_sub'));
work_pass2=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Featureslection_sub_DAN'));

%% �팱�Җ��̂ݔ����o���ăx�N�g���ɂ���
subinfo=dir(work_pass);% �팱�҂̖��O
n=length(subinfo);
subN={};%�팱�Җ��̃�k�X�g

NN=1;
for N=1:n
    if strlength(getfield(subinfo,{N},'name'))==9
        name=cellstr(subinfo(N).name);
         subN(NN)=name;
         NN=NN+1;
    end
end

%% �ϐ��쐬
Loss_sub=[];
Loss2_sub=[];

%% �팱�ҕ���
for i=2:length(subN)
    
subname=subN(i);

%% nirs�Cxdf�t�@�C�����w��

mkdir(fullfile(work_pass,'result'));
save_pass=char(fullfile(work_pass,'result'));

mkdir(fullfile(work_pass2,'result'));
save_pass2=char(fullfile(work_pass2,'result'));


%% �ǂݍ���
%�����ʑI���Ȃ�
cd(char(fullfile(work_pass,subname)))
Input_variable_nonfeatureslection=load('Input_variable.mat');
Input_variable_nonfeatureslection=Input_variable_nonfeatureslection.Input_variable;
Class_nonfeatureslection=load('Class.mat');
Class_nonfeatureslection=Class_nonfeatureslection.Class;

%�����ʑI������
cd(char(fullfile(work_pass2,subname)))
Input_variable_featureslection=load('Input_variable.mat');
Input_variable_featureslection=Input_variable_featureslection.Input_variable;
Class_featureslection=load('Class.mat');
Class_featureslection=Class_featureslection.Class;

%% LDA or QDA
switch LDA_QDA
    case 'LDA'
       %�����ʑI���Ȃ�
       Loss_sub=LDA_sub(Input_variable_nonfeatureslection,Class_nonfeatureslection,Loss_sub);

       %�����ʑI������
       Loss2_sub=LDA_sub(Input_variable_featureslection,Class_featureslection,Loss2_sub);

    case 'QDA'
       %�����ʑI���Ȃ�
       Loss_sub=QDA_sub(Input_variable_nonfeatureslection,Class_nonfeatureslection,Loss_sub);

       %�����ʑI������
       Loss2_sub=QDA_sub(Input_variable_featureslection,Class_featureslection,Loss2_sub);

end
end
%% t����
Accuracy_nonfeatureslection=(1-Loss_sub)*100;
Accuracy_featureslection=(1-Loss2_sub)*100;

[h,p]=Ttest(Accuracy_nonfeatureslection,Accuracy_featureslection,'No feature selection','Feature selection','Accuracy[%]')

%% �ۑ�
save(char(fullfile(save_pass,strcat(LDA_QDA,'_accuracy.mat'))),'Accuracy_nonfeatureslection');
save(char(fullfile(save_pass2,strcat(LDA_QDA,'_accuracy.mat'))),'Accuracy_featureslection');