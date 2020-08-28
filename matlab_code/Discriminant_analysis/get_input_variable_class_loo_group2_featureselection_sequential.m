function get_input_variable_class_loo_group2_featureselection_sequentialfs(SubNet_group,Class_group,LDA_QDA,selection_number)
%% saveディレクトリ作成

Feature_name='sequentialfs_forward';

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/',strcat('Featureslection_group2_loo_',Feature_name),LDA_QDA));

save_pass=work_pass;


%% 特徴量選択の入力でるデータ作成

Selection_variable=[];
Selection_group=SubNet_group(1:selection_number);

for t=1:length(Selection_group)

Selection_variable_label=[];

  for k=1:size(Selection_group{t},3)
    
    matrix_onelow=[];
    
      for i=1:size(Selection_group{t},1)-1
        for j=i+1:size(Selection_group{t},2)
          matrix_onelow=horzcat(matrix_onelow,Selection_group{t}(i,j,k));
        end 
      end
  
    Selection_variable_label=vertcat(Selection_variable_label,atanh(matrix_onelow));
  
  end

Selection_variable=vertcat(Selection_variable,Selection_variable_label);
end

%% 特徴選択の入力であるclass作成

Selection_Class=[];
Selection_Class_label=Class_group(1:selection_number);

 for m=1:size(Selection_Class_label,2)

       Selection_Class=vertcat(Selection_Class,Selection_Class_label{m});
 end


%% matrixを一行にし、LDA,QDAの入力であるInput_variable作成

SubNet_group2=SubNet_group;
SubNet_group2(1:selection_number)=[];
Input_variable=[];

for t=1:length(SubNet_group2)

Input_variable_label=[];

  for k=1:size(SubNet_group2{t},3)
    
    matrix_onelow=[];
    
      for i=1:size(SubNet_group2{t},1)-1
        for j=i+1:size(SubNet_group2{t},2)
          matrix_onelow=horzcat(matrix_onelow,SubNet_group2{t}(i,j,k));
        end 
      end
  
    Input_variable_label=vertcat(Input_variable_label,atanh(matrix_onelow));
  
  end

Input_variable=vertcat(Input_variable,Input_variable_label);
end

%% LDA,QDAの入力であるClass作成

Class_group2=Class_group;
Class_group2(1:selection_number)=[];
Class=[];

 for m=1:length(Class_group2)

       Class=vertcat(Class,Class_group2{m});
 end

 %% 逐次特徴選択
switch Feature_name
    
   case 'sequentialfs_backward'
     switch LDA_QDA
    
       case 'LDA'
          [Feature_number,history]=sequentialfs(@LDAtest_loo_group,Selection_variable,Selection_Class,'cv','none','direction','backward')
    
       case 'QDA'
          [Feature_number,history]=sequentialfs(@QDAtest_loo_group,Selection_variable,Selection_Class,'cv','none','direction','backward')
     end    
     
   case 'sequentialfs_forward'
     switch LDA_QDA
    
       case 'LDA'
          [Feature_number,history]=sequentialfs(@LDAtest_loo_group,Selection_variable,Selection_Class,'cv','none')
   
       case 'QDA'
          [Feature_number,history]=sequentialfs(@QDAtest_loo_group,Selection_variable,Selection_Class,'cv','none')
     end    
  
end

Input_variable=Input_variable(:,Feature_number);

%% 保存

save(char(fullfile(save_pass,strcat(int2str(selection_number),'_Input_variable.mat'))),'Input_variable');
save(char(fullfile(save_pass,strcat(int2str(selection_number),'_Class.mat'))),'Class');

end