function Loss=QDA_group_loo(Input_variable,Class)
%% LDA(loo)

Mdl = fitcdiscr(Input_variable,Class,'Leaveout','on','DiscrimType','pseudoquadratic','FillCoeffs','on');

Loss = kfoldLoss(Mdl);

end