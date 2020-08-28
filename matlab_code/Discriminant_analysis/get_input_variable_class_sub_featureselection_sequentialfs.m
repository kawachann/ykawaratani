function get_input_variable_class_sub_featureselection_sequentialfs(SubNet,lowRT,highRT,subname,LDA_QDA)
%% save�f�B���N�g���쐬

Feature_name='sequentialfs_backward';

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/',strcat('Featureslection_sub_',Feature_name),LDA_QDA));

mkdir(char(fullfile(work_pass,subname)));

save_pass=char(fullfile(work_pass,subname));

%% matrix����s�ɂ��ALDA,QDA�̓��͂ł���Input_variable�쐬

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

%% LDA,QDA�̓��͂ł���Class�쐬

Class=strings(length(lowRT)+length(highRT),1);
Class(1:length(lowRT),1)='OnTask';
Class(length(lowRT)+1:length(lowRT)+length(highRT),1)='MW';


%% ���������I��
switch LDA_QDA
    
    case 'LDA'
       [Feature_number,history]=sequentialfs(@LDAtest_sub,Input_variable,Class,'cv',size(Input_variable,1),'direction','backward');

       Input_variable=Input_variable(:,Feature_number);
       
    case 'QDA'
       [Feature_number,history]=sequentialfs(@QDAtest_sub,Input_variable,Class,'cv',size(Input_variable,1),'direction','backward');

       Input_variable=Input_variable(:,Feature_number);

end

%% �ۑ�

save(char(fullfile(save_pass,'Input_variable.mat')),'Input_variable');
save(char(fullfile(save_pass,'Class.mat')),'Class');

end

