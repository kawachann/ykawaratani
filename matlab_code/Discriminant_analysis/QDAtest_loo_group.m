 function err = QDAtest_loo_group(x,y)
 
%       Mdl = fitcdiscr(xtrain,ytrain,'DiscrimType','pseudoquadratic');
%       err = loss(Mdl,xtest,ytest);
%       a=mean(err);

Mdl = fitcdiscr(x,y,'Leaveout','on','DiscrimType','pseudoquadratic','FillCoeffs','on');

Loss = kfoldLoss(Mdl);
err=Loss
      
          if 0<Loss&&Loss<0.1
               b='wonderful'
          elseif 0.1<=Loss&&Loss<0.2
               b='great'
          elseif 0.2<=Loss&&Loss<0.3 
               b='good'
          elseif 0.3<=Loss&&Loss<0.4
               b='normal'
          else
               b='fuck'
          end
      
      