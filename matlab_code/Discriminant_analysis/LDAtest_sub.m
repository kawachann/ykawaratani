 function err = LDAtest_sub(xtrain,ytrain,xtest,ytest)
 
      Mdl = fitcdiscr(xtrain,ytrain,'DiscrimType','pseudolinear');
      err = loss(Mdl,xtest,ytest)