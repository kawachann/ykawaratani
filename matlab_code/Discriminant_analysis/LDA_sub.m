function Loss_sub=LDA_sub(Input_variable,Class,Loss_sub)
%% LDAi”íŒ±ÒŠÔj
Mdl = fitcdiscr(Input_variable,Class,'Leaveout','on','DiscrimType','pseudolinear');
Loss = kfoldLoss(Mdl);

Loss_sub=vertcat(Loss_sub,Loss);
end
