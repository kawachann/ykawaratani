function get_input_variable_class_loo_group_featureselection_sequentialfs(SubNet_group,Class_group,LDA_QDA)
%% saveディレクトリ作成

Feature_name='sequentialfs_forward';

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/',strcat('Featureslection_group_loo_',Feature_name),LDA_QDA));

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
          [Feature_number,history]=sequentialfs(@LDAtest_loo_group,Input_variable,Class,'cv','none','direction','backward')
    
       case 'QDA'
          [Feature_number,history]=sequentialfs(@QDAtest_loo_group,Input_variable,Class,'cv','none','direction','backward')
     end    
     
   case 'sequentialfs_forward'
     switch LDA_QDA
    
       case 'LDA'
          [Feature_number,history]=sequentialfs(@LDAtest_loo_group,Input_variable,Class,'cv','none')
   
       case 'QDA'
          [Feature_number,history]=sequentialfs(@QDAtest_loo_group,Input_variable,Class,'cv','none')
     end    
  
end

Input_variable=Input_variable(:,Feature_number);

%% 保存

save(char(fullfile(save_pass,'Input_variable.mat')),'Input_variable');
save(char(fullfile(save_pass,'Class.mat')),'Class');
save(char(fullfile(save_pass,'history.mat')),'history');
end