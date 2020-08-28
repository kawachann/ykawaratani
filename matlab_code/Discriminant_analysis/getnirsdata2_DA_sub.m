function SubNet2=getnirsdata2_DA_sub(highRT,lowRT,hb,NIRx,file_pass_nirs,subname,Feature_name_sub)
%% 変数作成 

%特徴量
switch Feature_name_sub
    
    case 'DMN'
      cd(fullfile(file_pass_nirs));
      label=load(strcaat(subname,'region.mat'))
      label2=label.region;
      IndexC = strfind(label2(:,2),'1');
      Feature_value= find(not(cellfun('isempty',IndexC)));
      X=zeros(length(Feature_value));
      Y=zeros(length(Feature_value));
      
     case 'DAN'
       cd(fullfile(file_pass_nirs));
       label=load(strcaat(subname,'region.mat'))
       label2=label.region;
       IndexC = strfind(label2(:,3),'1');
       Feature_value= find(not(cellfun('isempty',IndexC)));
       X=zeros(length(Feature_value));
       Y=zeros(length(Feature_value));
      
end

hbdata=[];
SubMWNet=[];
SubOnTaskNet=[];

%% ショートディスタンス取り除き
for k=1:120
    if hb.probe.link{k,'detector'}<15&&rem(k,2)~=0
       hbdata=horzcat(hbdata, hb.data(:,k));
    end
end

%% PresenデータとNIRSデータの対応付、matrix作成
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
     MWTriger_feature_value=MWTriger(:,Feature_value);
     x=corrcoef(MWTriger_feature_value);
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
    OnTaskTriger_feature_value=OnTaskTriger(:,Feature_value);
    y=corrcoef(OnTaskTriger_feature_value);
    SubOnTaskNet=cat(3,SubOnTaskNet,y);
    
end

SubNet2=cat(3,SubOnTaskNet,SubMWNet);

%% 全被験者のmatrixとclass格納
% %グループのクラス作成
% Class2=[];
% Class2=strings(length(lowRT)+length(highRT),1);
% Class2(1:length(lowRT),1)='OnTask';
% Class2(length(lowRT)+1:length(lowRT)+length(highRT),1)='MW';


end