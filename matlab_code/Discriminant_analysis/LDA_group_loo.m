function Loss=LDA_group_loo(Input_variable,Class)
%% LDA(loo)

Mdl = fitcdiscr(Input_variable,Class,'Leaveout','on','DiscrimType','pseudolinear','FillCoeffs','on');

Loss = kfoldLoss(Mdl);

end