function[happy2]=ttestNIRS(EntireOnTaskNIRS,EntireMWNIRS,subN)


 happy=[];
 happy2=[];
 
for k=1:length(EntireOnTaskNIRS)-1
for n=k+1:length(EntireOnTaskNIRS)
     OnTask=[];
     MW=[];
    for  m=1:length(subN)-1
        
        OnTask=vertcat(OnTask,EntireOnTaskNIRS(k,n,m));
        MW=vertcat(MW,EntireMWNIRS(k,n,m));
    end
  
[h,p] = ttest(OnTask,MW);
if p<0.05
    name=strcat(strcat(string(k),'-'),string(n))
    happy=horzcat(p,name);
    happy2=vertcat(happy2,happy);
    figure
boxplot([OnTask MW],'labels',{'BRT下位10%','BRT上位10%'});
ylabel(strcat('機能的結合データ',name))

end
end
end

end


