function get_input_variable_class_loso_group_featureselection_sequentialfs(SubNet_group,Class_group,LDA_QDA)
%% saveディレクトリ作成

Feature_name='sequentialfs_forward';

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/',strcat('Featureslection_group_loso_',Feature_name),LDA_QDA));

save_pass=work_pass;

%% matrixを一行にし、LDA,QDAの入力であるInput_variable作成

Input_variable=[];

for t=1:length(SubNet_group)

Input_variable_label=[];

  for k=1:size(SubNet_group{t},3)
    
    matrix_onelow=[];
    
      for i=1:size(SubNet_group{t},1)-1
        for j=i+1:size(SubNet_group{t},2)
          matrix_onelow=horzcat(matrix_onelow,SubNet_group{t}(i,j,k));
        end 
      end
  
    Input_variable_label=vertcat(Input_variable_label,atanh(matrix_onelow));
  
  end

Input_variable=vertcat(Input_variable,Input_variable_label);
end

%% LDA,QDAの入力であるClass作成
Class=[];

 for m=1:length(SubNet_group)

       Class=vertcat(Class,Class_group{m});
 end

 %% 逐次特徴選択
switch Feature_name
    
   case 'sequentialfs_backward'
     switch LDA_QDA
    
       case 'LDA'
          [Feature_number,history]=sequentialfs(@LDAtest_loso_group,Input_variable,Class,'cv','none','direction','backward')
    
       case 'QDA'
          [Feature_number,history]=sequentialfs(@QDAtest_loso_group,Input_variable,Class,'cv','none','direction','backward')
     end    
     
   case 'sequentialfs_forward'
     switch LDA_QDA
    
       case 'LDA'
          [Feature_number,history]=sequentialfs(@LDAtest_loso_group,Input_variable,Class,'cv','none')
   
       case 'QDA'
          [Feature_number,history]=sequentialfs(@QDAtest_loso_group,Input_variable,Class,'cv','none')
     end    
  
end
%% testデータ作成
for t=1:length(SubNet_group)

Test_variable_label=[];

 for k=1:size(SubNet_group{t},3)

    Testmatrix_onelow=[];

      for i=1:size(SubNet_group{t},1)-1
        for j=i+1:size(SubNet_group{t},2)
          Testmatrix_onelow=horzcat(Testmatrix_onelow,SubNet_group{t}(i,j,k));
        end 
      end

    Test_variable_label=vertcat(Test_variable_label,atanh(Testmatrix_onelow));

  end

Test_variable{t}=Test_variable_label;

end


%% trainデータ作成
for n=1:length(SubNet_group)

TrainSubNet_label=[];
Trainclass_label=[];

 for m=1:length(SubNet_group)

   if m~=n
       TrainSubNet_label=cat(3,TrainSubNet_label,SubNet_group{m});
       Trainclass_label=vertcat(Trainclass_label,Class_group{m});
   end

 end

TrainSubNet_group{n}=TrainSubNet_label;
Train_class{n}=Trainclass_label;

end


for t=1:length(TrainSubNet_group)

Train_variable_label=[];

  for k=1:size(TrainSubNet_group{t},3)
    
    Trainmatrix_onelow=[];
    
      for i=1:size(TrainSubNet_group{t},1)-1
        for j=i+1:size(TrainSubNet_group{t},2)
          Trainmatrix_onelow=horzcat(Trainmatrix_onelow,TrainSubNet_group{t}(i,j,k));
        end 
      end
  
    Train_variable_label=vertcat(Train_variable_label,atanh(Trainmatrix_onelow));
  
  end

Train_variable{t}=Train_variable_label;

end

Test_class=Class_group;
%% データ作成

for i=1:size(Train_variable,2)

    Train_variable{i}=Train_variable{i}(:,Feature_number)
    Test_variable{i}=Test_variable{i}(:,Feature_number)
    
end

%% 保存
save(char(fullfile(save_pass,'Train_variable.mat')),'Train_variable');
save(char(fullfile(save_pass,'Train_class.mat')),'Train_class');
save(char(fullfile(save_pass,'Test_variable.mat')),'Test_variable');
save(char(fullfile(save_pass,'Test_class.mat')),'Test_class');
save(char(fullfile(save_pass,'history.mat')),'history');
end