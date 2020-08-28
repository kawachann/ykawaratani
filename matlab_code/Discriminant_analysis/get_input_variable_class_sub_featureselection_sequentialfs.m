function get_input_variable_class_sub_featureselection_sequentialfs(SubNet,lowRT,highRT,subname,LDA_QDA)
%% saveディレクトリ作成

Feature_name='sequentialfs_backward';

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/',strcat('Featureslection_sub_',Feature_name),LDA_QDA));

mkdir(char(fullfile(work_pass,subname)));

save_pass=char(fullfile(work_pass,subname));

%% matrixを一行にし、LDA,QDAの入力であるInput_variable作成

Input_variable=[];

for k=1:length(SubNet(1,1,:))
    
    Matrix_onelow=[];
    
    for i=1:length(SubNet)-1
      for j=i+1:length(SubNet)
        Matrix_onelow=horzcat(Matrix_onelow,SubNet(i,j,k));
      end 
    end
  
    Input_variable=vertcat(Input_variable,atanh(Matrix_onelow));
  
end

%% LDA,QDAの入力であるClass作成

Class=strings(length(lowRT)+length(highRT),1);
Class(1:length(lowRT),1)='OnTask';
Class(length(lowRT)+1:length(lowRT)+length(highRT),1)='MW';


%% 逐次特徴選択
switch LDA_QDA
    
    case 'LDA'
       [Feature_number,history]=sequentialfs(@LDAtest_sub,Input_variable,Class,'cv',size(Input_variable,1),'direction','backward');

       Input_variable=Input_variable(:,Feature_number);
       
    case 'QDA'
       [Feature_number,history]=sequentialfs(@QDAtest_sub,Input_variable,Class,'cv',size(Input_variable,1),'direction','backward');

       Input_variable=Input_variable(:,Feature_number);

end

%% 保存

save(char(fullfile(save_pass,'Input_variable.mat')),'Input_variable');
save(char(fullfile(save_pass,'Class.mat')),'Class');

end

