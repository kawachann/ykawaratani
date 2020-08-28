clear
%% 入力データ

LDA_QDA='LDA'

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Featureslection_group_loo_sequentialfs_forward/LDA'));

%% nirs，xdfファイル名指定

mkdir(fullfile(work_pass,'result'));

save_pass=char(fullfile(work_pass,'result'));


%% 読み込み

cd(char(fullfile(work_pass)))

Input_variable=load('Input_variable.mat');
Input_variable=Input_variable.Input_variable;

Class=load('Class.mat');
Class=Class.Class;

%% LDA or QDA
switch LDA_QDA
    
    case 'LDA'
      Loss=LDA_group_loo(Input_variable,Class);

    case 'QDA'
      Loss=QDA_group_loo(Input_variable,Class);
       
end

Accuracy=(1-Loss)*100;

%% 保存

save(char(fullfile(save_pass,strcat(LDA_QDA,'_accuracy.mat'))),'Accuracy');