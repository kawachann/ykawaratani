function get_input_variable_class_sub_Nonfeatureselection(SubNet,lowRT,highRT,subname)
%% save�f�B���N�g���쐬

work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/Discriminant_analysis/Non_featureslection_sub'));

mkdir(char(fullfile(work_pass,subname)));

save_pass=char(fullfile(work_pass,subname));

%% matrix����s�ɂ��ALDA�̓��͂ł���Input_variable�쐬

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

%% LDA�̓��͂ł���Class�쐬

Class=strings(length(lowRT)+length(highRT),1);
Class(1:length(lowRT),1)='OnTask';
Class(length(lowRT)+1:length(lowRT)+length(highRT),1)='MW';

%% �ۑ�
save(char(fullfile(save_pass,'Input_variable.mat')),'Input_variable');
save(char(fullfile(save_pass,'Class.mat')),'Class');
end
