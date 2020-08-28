function Tentativeloss_group=LDA_loo_group(SubNet_group,Class_group)
%% matrix����s�ɂ��ALDA�̓��͂ł���Input_variable�쐬
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

%% LDA�̓��͂ł���Class�쐬
Class=[];

 for m=1:length(SubNet_group)

       Class=vertcat(Class,Class_group{m});
 end

%% LDA
Mdl = fitcdiscr(Input_variable,Class,'Leaveout','on','DiscrimType','pseudolinear','FillCoeffs','on');
Tentativeloss_group = kfoldLoss(Mdl);
end