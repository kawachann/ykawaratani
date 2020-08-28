 function err = QDAtest_loso_group_(x,y)
 
 
%   Mdl = fitcdiscr(x,y,'DiscrimType','pseudolinear');
%   err = loss(Mdl,x(2,:),y(2,:))
 
 
label=[0,12,8,10,10,10,10,10,10,10,10,10,10,11];
      
Loss_group=[];

for i=1:length(label)-1
     
x1=x;
y1=y;

Test_variable=x1(sum(label(1:i))+1:sum(label(1:i+1)),:); 
Test_class=y1(sum(label(1:i))+1:sum(label(1:i+1)),:);

x1(sum(label(1:i))+1:sum(label(1:i+1)),:)=[];
Train_variable=x1;

y1(sum(label(1:i))+1:sum(label(1:i+1)),:)=[];
Train_class=y1;

Mdl = fitcdiscr(Train_variable,Train_class,'DiscrimType','pseudoquadratic');

Loss = loss(Mdl,Test_variable,Test_class);
Loss_group=vertcat(Loss_group,Loss);

end
err=mean(Loss_group)
