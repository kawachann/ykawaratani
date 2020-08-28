 function Mu=QDA2_sub(Input_variable,Class,Loss_sub)
%% QDA（被験者間）
Mdl = fitcdiscr(Input_variable,Class,'Leaveout','on','DiscrimType','pseudoquadratic','FillCoeffs','on');

Mu=Mdl.Trained{1,1}.Mu

end
