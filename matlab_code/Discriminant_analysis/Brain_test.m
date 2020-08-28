clear
%% 入力データ
LDA_QDA='QDA'

work_pass2=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Featureslection_sub_sequentialfs_forward/QDA'));
%% 被験者名のみ抜き出してベクトルにする
subinfo=dir(work_pass2);% 被験者の名前
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
Loss_sub=[];
Loss2_sub=[];

%% 被験者分回す
for i=2:length(subN)
    
subname=subN(i);

%% 読み込み
%特徴量選択あり
cd(char(fullfile(work_pass2,subname)))
Input_variable_featureslection=load('Input_variable.mat');
Input_variable=Input_variable_featureslection.Input_variable;
Class_featureslection=load('Class.mat');
Class=Class_featureslection.Class;

%% LDA or QDA
switch LDA_QDA
    case 'LDA'
       %特徴量選択あり
       Mu=LDA2_sub(Input_variable,Class,Loss2_sub);

    case 'QDA'
       %特徴量選択あり
       Mu=QDA2_sub(Input_variable,Class,Loss2_sub);

end

work_pass3=char(fullfile(work_pass2,subname));
save(char(fullfile(work_pass3,strcat(subname,'_mu.mat'))),'Mu');

end