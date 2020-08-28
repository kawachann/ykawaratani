function[SubNet,MWNIRS,OnTaskNIRS]=getnirsdata2(highRT,lowRT,hb,NIRx,save_pass,subname)
 
MWNIRS=[];
OnTaskNIRS=[];
x=[];
X=zeros(33);
y=[];
Y=zeros(33);
hbdata=[];
NIRxhighlabel=0;
NIRxlowlabel=0;
SubMWNet=[];
SubOnTaskNet=[];

%ショートディスタンス取り除き
for k=1:120
    if hb.probe.link{k,'detector'}<15&&rem(k,2)~=0
       hbdata=horzcat(hbdata, hb.data(:,k));
    end
end
 
for i=1:length(highRT)
    MWnumber=[];
    MWTriger=[];
    NIRxhighlabel=knnsearch(NIRx(1,:)',highRT(1,i));
     for j=1:length(NIRx)
         if NIRx(1,NIRxhighlabel)-NIRx(1,j)<10&&NIRx(1,NIRxhighlabel)-NIRx(1,j)>0
            MWnumber=horzcat(MWnumber,NIRx(2,j));
         end
     end
     
     MWTriger=hbdata(MWnumber,:);
     
     MWTriger(:,[2,7,8,22,25,26,28,30,40,42,44])=[]
     x=corrcoef(MWTriger);
     SubMWNet=cat(3,SubMWNet,x);
end
 
 
for i=1:length(lowRT)
    OnTasknumber=[];
    OnTaskTriger=[];
     NIRxlowlabel=knnsearch(NIRx(1,:)',lowRT(1,i));
     for j=1:length(NIRx)
         if  NIRx(1,NIRxlowlabel)-NIRx(1,j)<10&&NIRx(1,NIRxlowlabel)-NIRx(1,j)>0
            OnTasknumber=horzcat(OnTasknumber,NIRx(2,j));
         end
     end
     
     OnTaskTriger=hbdata(OnTasknumber,:);
     
     
     OnTaskTriger(:,[2,7,8,22,25,26,28,30,40,42,44])=[]
      y=corrcoef(OnTaskTriger);
      SubOnTaskNet=cat(3,SubOnTaskNet,y);
end

SubNet=cat(3,SubOnTaskNet,SubMWNet);
save(char(fullfile(save_pass,strcat(subname,'_Network2_10%.mat'))),'SubNet');


 
end