function get_input_variable_class_loo_group_featureslection(SubNet2_group,Class2_group,Feature_name_group)
%% save�f�B���N�g���쐬

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/',strcat('Featureslection_group_loo_',Feature_name_group)));

save_pass=work_pass;

%% matrix����s�ɂ��ALDA�̓��͂ł���Input_variable�쐬
Input_variable=[];
for t=1:length(SubNet2_group)

Input_variable_label=[];

  for k=1:size(SubNet2_group{t},3)
    
    matrix_onelow=[];
    
      for i=1:size(SubNet2_group{t},1)-1
        for j=i+1:size(SubNet2_group{t},2)
          matrix_onelow=horzcat(matrix_onelow,SubNet2_group{t}(i,j,k));
        end 
      end
  
    Input_variable_label=vertcat(Input_variable_label,atanh(matrix_onelow));
  
  end

Input_variable=vertcat(Input_variable,Input_variable_label);
end

%% LDA�̓��͂ł���Class�쐬
Class=[];

 for m=1:length(SubNet2_group)

       Class=vertcat(Class,Class2_group{m});
 end

%% �ۑ�
save(char(fullfile(save_pass,'Input_variable.mat')),'Input_variable');
save(char(fullfile(save_pass,'Class.mat')),'Class');
end