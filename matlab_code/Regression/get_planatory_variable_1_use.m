function[planatory_variable_1_use]=get_explanatory_variable_1_use(hb,NIRx,BRT1)
 
Fc=[];
hbdata=[];
explanatory_variable_1_use=[];
%ショートディスタンス取り除き
for k=1:120
    if hb.probe.link{k,'detector'}<15&&rem(k,2)~=0
       hbdata=horzcat(hbdata, hb.data(:,k));
    end
end
 
 for i=1:length(BRT1)
    BRTnumber=[];
    BRTTriger=[];
     Onelow=[];
   onelowlabel=[];
    NIRxhighlabel=knnsearch(NIRx(1,:)',BRT1(1,i));
     for j=1:length(NIRx)
         if NIRx(1,NIRxhighlabel)-NIRx(1,j)<10&&NIRx(1,NIRxhighlabel)-NIRx(1,j)>0
            BRTnumber=horzcat(BRTnumber,NIRx(2,j));
         end
     end
     for s=1:length(BRTnumber)
        BRTTriger=vertcat(BRTTriger,hbdata(BRTnumber(1,s),:));
     end
     Fc=corrcoef(BRTTriger);
     
   for m=1:length(Fc)-1
    for n=m+1:length(Fc)
        onelowlabel=horzcat(onelowlabel,Fc(m,n));
    end 
   end
   
  Onelow=atanh(onelowlabel);
  explanatory_variable_1_use=vertcat(explanatory_variable_1_use,Onelow);
 
end