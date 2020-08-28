function[Onelow,save_pass_mds,save_pass_tsne,distancename_mds,distancename_tsne,Loss_group_mds,Loss_group_tsne]=onelow(SubNet,Onelow,lowRT,highRT,subname,Loss_group_mds,Loss_group_tsne)

%% 1������
substate=[];

for k=1:length(SubNet(1,1,:))
    Onelowlabel=[];
    subonelow=[];
  for i=1:length(SubNet)-1
    for j=i+1:length(SubNet)
        subonelow=horzcat(subonelow,SubNet(i,j,k));
    end 
  end
  Onelowlabel=atanh(subonelow);
  Onelow=vertcat(Onelow,Onelowlabel);
  substate=vertcat(substate,Onelowlabel);
end

%% tsne��mds��p�����팱�҂��Ƃ�plot
%�����v�ʌ���
distancename_mds='correlation';
distancename_tsne='correlation';
save_pass_mds=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/brain/fig/mds',distancename_mds));
save_pass_tsne=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/brain/fig/tsne',distancename_tsne));

Loss_group_mds=mds_sub(substate,lowRT,highRT,subname,distancename_mds,save_pass_mds,Loss_group_mds);
Loss_group_tsne=tsne_sub(substate,lowRT,highRT,subname,distancename_tsne,save_pass_tsne,Loss_group_tsne);

end