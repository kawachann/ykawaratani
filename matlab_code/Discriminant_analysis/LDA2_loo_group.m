function Tentativeloss2_group=LDA2_loo_group(SubNet2_group,Class2_group)
%% matrix‚ğˆês‚É‚µALDA‚Ì“ü—Í‚Å‚ ‚éInput_variableì¬
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

%% LDA‚Ì“ü—Í‚Å‚ ‚éClassì¬
Class=[];

 for m=1:length(SubNet2_group)

       Class=vertcat(Class,Class2_group{m});
 end

%% LDA
Mdl = fitcdiscr(Input_variable,Class,'Leaveout','on','DiscrimType','pseudolinear','FillCoeffs','on');
Tentativeloss2_group = kfoldLoss(Mdl);