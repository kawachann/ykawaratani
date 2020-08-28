clear
%% 入力データ
LDA_QDA='LDA'

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Featureslection_group_loso_sequentialfs_forward/LDA'));

%% nirs，xdfファイル名指定

mkdir(fullfile(work_pass,'result'));

save_pass=char(fullfile(work_pass,'result'));

%% 読み込み

cd(char(fullfile(work_pass)))

Train_variable=load('Train_variable.mat');
Train_variable=Train_variable.Train_variable;

Train_class=load('Train_class.mat');
Train_class=Train_class.Train_class;

Test_variable=load('Test_variable.mat');
Test_variable=Test_variable.Test_variable;

Test_class=load('Test_class.mat');
Test_class=Test_class.Test_class;

%% LDA
switch LDA_QDA
    
    case 'LDA'
        Loss=LDA_group_loso(Train_variable,Train_class,Test_variable,Test_class)

    case 'QDA'
         Loss=QDA_group_loso(Train_variable,Train_class,Test_variable,Test_class)
       
end
Accuracy=(1-Loss)*100;

%% 保存

save(char(fullfile(save_pass,strcat(LDA_QDA,'_accuracy.mat'))),'Accuracy');
