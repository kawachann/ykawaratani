function Loss_sub=QDA_sub(Input_variable,Class,Loss_sub)
%% QDA�i�팱�Ҋԁj
Mdl = fitcdiscr(Input_variable,Class,'Leaveout','on','DiscrimType','pseudoquadratic');
Loss = kfoldLoss(Mdl);

Loss_sub=vertcat(Loss_sub,Loss);
end
