clear
work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Non_featureslection_group_loso'));
work_pass2=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Featureslection_group_loso_sequentialfs_forward/LDA'));

%% ”]—ÌˆæŠ„‚è“–‚Ä

cd(fullfile(work_pass));
Input_variable1=load('Train_variable.mat');
Input_variable1=Input_variable1.Train_variable;
Input_variable1=Input_variable1{1};

cd(fullfile(work_pass2));
Input_variable2=load('Train_variable.mat');
Input_variable2=Input_variable2.Train_variable;
Input_variable2=Input_variable2{1};


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
 
 