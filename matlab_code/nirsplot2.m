function[count,subcount]=nirsplot2(highRT,lowRT,hb,NIRx,count,subcount)
 
MWNIRS=[];
OnTaskNIRS=[];
x=[];
t=[];
y=[];
hbdata=[];
NIRxhighlabel=0;
NIRxlowlabel=0;


%ショートディスタンス取り除き
for k=1:120
    if hb.probe.link{k,'detector'}<15&&rem(k,2)~=0
       hbdata=horzcat(hbdata, hb.data(:,k));
    end
end

subcount=subcount+1
if rem(count,13)~=0
    count=13*(subcount-1);
end

 for i=1:length(lowRT)
    count=count+1;
    OnTasknumber=[];
    OnTaskTriger=[];
     NIRxlowlabel=knnsearch(NIRx(1,:)',lowRT(1,i));
     for j=1:length(NIRx)
         if  NIRx(1,NIRxlowlabel)-NIRx(1,j)<10&&NIRx(1,NIRxlowlabel)-NIRx(1,j)>0
            OnTasknumber=horzcat(OnTasknumber,NIRx(2,j));
         end
     end
     for s=1:length(OnTasknumber)
         OnTaskTriger=vertcat(OnTaskTriger,hbdata(OnTasknumber(1,s),:));
     end
      y=corrcoef(OnTaskTriger);
      subplot(13,13,count), clims=[-1,1],imagesc(y,clims) ,axis image
      %h=heatmap(y,'ColorbarVisible','off','ColorLimits',[-1 1],'Colormap',parula)
      
end
 
 
if length(lowRT)~=6
    count=count+1;
end
count=count+1;

for i=1:length(highRT)
    count=count+1;
    MWnumber=[];
    MWTriger=[];
    NIRxhighlabel=knnsearch(NIRx(1,:)',highRT(1,i));
     for j=1:length(NIRx)
         if NIRx(1,NIRxhighlabel)-NIRx(1,j)<10&&NIRx(1,NIRxhighlabel)-NIRx(1,j)>0
            MWnumber=horzcat(MWnumber,NIRx(2,j));
         end
     end
     for s=1:length(MWnumber)
        MWTriger=vertcat(MWTriger,hbdata(MWnumber(1,s),:));
     end
     x=corrcoef(MWTriger);
     subplot(13,13,count), clims=[-1,1],imagesc(x,clims) ,axis image
     %h=heatmap(x,'ColorbarVisible','off','ColorLimits',[-1 1],'Colormap',parula)
     
 end


end