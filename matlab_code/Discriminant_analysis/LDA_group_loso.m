function Loss=LDA_group_loso(Train_variable,Train_class,Test_variable,Test_class)
%% LOSO

Loss=[];

for i=1:size(Train_variable,2)

Mdl = fitcdiscr(Train_variable{i},Train_class{i},'DiscrimType','pseudolinear');

Loss_label =loss(Mdl,Test_variable{i},Test_class{i},'LossFun','classiferror');

Loss=vertcat(Loss,Loss_label);

end

end