function[SubNet,MWNIRS,OnTaskNIRS]=getnirsdata(highRT,lowRT,hb,NIRx,save_pass,subname)
 
MWNIRS=[];
OnTaskNIRS=[];
x=[];
X=zeros(44);
y=[];
Y=zeros(44);
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

% highlabel=max(highRT(2,:));
% lowlabel=min(lowRT(2,:));
% for k=1:length(highRT)
%     if highlabel==highRT(2,k)
%          highestRT=highRT(1,k);
%     end
% end
%  for w=1:length(lowRT)
%     if lowlabel==lowRT(2,w)
%          lowestRT=lowRT(1,w);
%     end
% end 
    
   

% MWnumber=[];
% MWTriger=[];
%      for j=1:length(NIRx)
%          if highestRT-NIRx(1,j)<10&&highestRT-NIRx(1,j)>0
%             MWnumber=horzcat(MWnumber,NIRx(2,j));
%          end
%      end
%      for s=1:length(MWnumber)
%         MWTriger=vertcat(MWTriger,hbdata(MWnumber(1,s),:));
%      end
%      MWNIRS=corrcoef(MWTriger);
% 
%  OnTasknumber=[];
%  OnTaskTriger=[];
%      for j=1:length(NIRx)
%          if lowestRT-NIRx(1,j)<10&&lowestRT-NIRx(1,j)>0
%             OnTasknumber=horzcat(OnTasknumber,NIRx(2,j));
%          end
%      end
%      for s=1:length(OnTasknumber)
%          OnTaskTriger=vertcat(OnTaskTriger,hbdata(OnTasknumber(1,s),:));
%      end
%       OnTaskNIRS=corrcoef(OnTaskTriger);


% for i=1:length(highRT)
%     MWnumber=[];
%     MWTriger=[];
%      for j=1:length(NIRx)
%          if highRT(1,i)-NIRx(1,j)<10&&highRT(1,i)-NIRx(1,j)>0
%             MWnumber=horzcat(MWnumber,NIRx(2,j));
%          end
%      end
%      for s=1:length(MWnumber)
%         MWTriger=vertcat(MWTriger,hbdata(MWnumber(1,s),:));
%      end
%      x=corrcoef(MWTriger);
%      X=X+x;
%  end
%  MWNIRS=X/length(highRT);
%  
% for i=1:length(lowRT)
%     OnTasknumber=[];
%     OnTaskTriger=[];
%      for j=1:length(NIRx)
%          if lowRT(1,i)-NIRx(1,j)<10&&lowRT(1,i)-NIRx(1,j)>0
%             OnTasknumber=horzcat(OnTasknumber,NIRx(2,j));
%          end
%      end
%      for s=1:length(OnTasknumber)
%          OnTaskTriger=vertcat(OnTaskTriger,hbdata(OnTasknumber(1,s),:));
%      end
%       y=corrcoef(OnTaskTriger);
%       Y=Y+y;
% end
%  OnTaskNIRS=Y/length(lowRT);
 
 for i=1:length(highRT)
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
     SubMWNet=cat(3,SubMWNet,x);
     X=X+x;
 end
 MWNIRS=X/length(highRT);
 
 
for i=1:length(lowRT)
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
      SubOnTaskNet=cat(3,SubOnTaskNet,y);
      Y=Y+y;
end
SubNet=cat(3,SubOnTaskNet,SubMWNet);
save(char(fullfile(save_pass,strcat(subname,'_Network_10%.mat'))),'SubNet');
 OnTaskNIRS=Y/length(lowRT);

 
end