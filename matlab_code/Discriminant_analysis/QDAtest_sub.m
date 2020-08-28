 function err = QDAtest_sub(xtrain,ytrain,xtest,ytest)
 
      Mdl = fitcdiscr(xtrain,ytrain,'DiscrimType','pseudoquadratic');
      err = loss(Mdl,xtest,ytest);