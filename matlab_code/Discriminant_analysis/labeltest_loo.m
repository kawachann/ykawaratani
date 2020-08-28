clear
work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Non_featureslection_group_loo'));
work_pass2=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Featureslection_group_loo_sequentialfs_forward/LDA'));

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

cd(fullfile(work_pass));
Input_variable1=load('Input_variable.mat');
Input_variable1=Input_variable1.Input_variable;


cd(fullfile(work_pass2));
Input_variable2=load('Input_variable.mat');
Input_variable2=Input_variable2.Input_variable;

label=[];
for i=1:size(Input_variable1,2)
    for j=1:size(Input_variable2,2)
     if Input_variable1(:,i)==Input_variable2(:,j)
        
        label=horzcat(label,i);
        
     end
    end
end

name_label=[];

 for i=1:44
    for j=i+1:44
        name_label=vertcat(name_label,horzcat(i,j));
    end 
 end

 Brain_label=name_label(label,:);
 
 save(char(fullfile(work_pass2,'label.mat')), 'Brain_label');
 
 