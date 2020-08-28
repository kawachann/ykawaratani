clear
work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Non_featureslection_sub'));
work_pass2=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Featureslection_sub_sequentialfs_forward/QDA'));

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

for i=2:length(subN)
    
subname=subN(i);

work_pass3=char(fullfile(work_pass,subname));
cd(fullfile(work_pass3));
Input_variable1=load('Input_variable.mat');
Input_variable1=Input_variable1.Input_variable;

work_pass4=char(fullfile(work_pass2,subname));
cd(fullfile(work_pass4));
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


work_pass5=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/brain',subname));
cd(fullfile(work_pass5));
region=load('region.mat');
region=region.region;
name_label=[];

 for i=1:length(region)-1
    for j=i+1:length(region)
        name_label=horzcat(name_label,strcat(region(i,1),region(j,1)));
    end 
 end

 Brain_label=name_label(label);
 
 save(char(fullfile(work_pass4,strcat(subname,'label.mat'))), 'Brain_label');
 
 
end