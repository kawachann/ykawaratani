function Loss2_group=LDA2_loso_group(SubNet2_group,Class2_group)

%% testデータ作成
for t=1:length(SubNet2_group)

Test_variable_label=[];

 for k=1:size(SubNet2_group{t},3)

    Testmatrix_onelow=[];

      for i=1:size(SubNet2_group{t},1)-1
        for j=i+1:size(SubNet2_group{t},2)
          Testmatrix_onelow=horzcat(Testmatrix_onelow,SubNet2_group{t}(i,j,k));
        end 
      end

    Test_variable_label=vertcat(Test_variable_label,atanh(Testmatrix_onelow));

  end

Test_variable{t}=Test_variable_label;

end


%% trainデータ作成
for n=1:length(SubNet2_group)

TrainSubNet_label=[];
Trainclass_label=[];

 for m=1:length(SubNet2_group)

   if m~=n
       TrainSubNet_label=cat(3,TrainSubNet_label,SubNet2_group{m});
       Trainclass_label=vertcat(Trainclass_label,Class2_group{m});
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

%% LOSO
Loss2_group=[];
for i=1:length(SubNet2_group)

Mdl = fitcdiscr(Train_variable{i},Train_class{i},'DiscrimType','pseudolinear');

Test_class=Class2_group{i};
Loss = loss(Mdl,Test_variable{i},Test_class);
Loss2_group=vertcat(Loss2_group,Loss);

end

end