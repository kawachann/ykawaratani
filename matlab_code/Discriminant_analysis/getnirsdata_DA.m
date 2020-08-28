function [SubNet,SubNet_group,Class_group,label1]=getnirsdata_DA(highRT,lowRT,hb,NIRx,SubNet_group,Class_group,label1)
 
X=zeros(44);
Y=zeros(44);
hbdata=[];
SubNet=[];
SubMWNet=[];
SubOnTaskNet=[];

%% �V���[�g�f�B�X�^���X��菜��
for k=1:120
    if hb.probe.link{k,'detector'}<15&&rem(k,2)~=0
       hbdata=horzcat(hbdata, hb.data(:,k));
    end
end

%% Presen�f�[�^��NIRS�f�[�^�̑Ή��t�Amatrix�쐬
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
    y=corrcoef(OnTaskTriger);
    SubOnTaskNet=cat(3,SubOnTaskNet,y);
    
end

SubNet=cat(3,SubOnTaskNet,SubMWNet);
%% �S�팱�҂�matrix��class�i�[
%�팱�҂̃N���X�쐬
Class=strings(length(lowRT)+length(highRT),1);
Class(1:length(lowRT),1)='OnTask';
Class(length(lowRT)+1:length(lowRT)+length(highRT),1)='MW';

%�S�팱�҂�matrix��class�i�[
Class_group{label1}=Class;
SubNet_group{label1}=SubNet;
label1=label1+1;

end