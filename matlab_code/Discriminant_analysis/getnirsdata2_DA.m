function [SubNet2,SubNet2_group,Class2_group,label2]=getnirsdata2_DA(highRT,lowRT,hb,NIRx,SubNet2_group,Class2_group,label2,Feature_name_group)
%% 変数作成 

%特徴選択（基準点４点レジスト）
%DMN:[1,3,4,5,6,15,16,17,18,23,24,31,43]
%DAN:[1,3,4,9,12,14,20,21,27,29,34,35,37,39,41]

%特徴選択（基準点5点レジスト）
%DMN:[1,4,5,6,15,16,17,22,24,35,41.42]
%DAN:[4,9,12,13,14,18,20,21,22,30,34,37,39,43,44]

switch Feature_name_group
    
    case 'DMN'
        Feature_value=[1,4,5,6,15,16,17,22,24,35,41,42];
        
    case 'DAN'
        Feature_value=[4,9,12,13,14,18,20,21,22,30,34,37,39,43,44];
        
end

X=zeros(length(Feature_value));
Y=zeros(length(Feature_value));

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
%被験者のクラス作成
Class=strings(length(lowRT)+length(highRT),1);
Class(1:length(lowRT),1)='OnTask';
Class(length(lowRT)+1:length(lowRT)+length(highRT),1)='MW';

%全被験者のmatrixとclass格納
Class2_group{label2}=Class
SubNet2_group{label2}=SubNet2;
label2=label2+1


end