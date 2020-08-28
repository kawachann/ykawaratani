function[Coordinates,Coordinates3]=mds(Onelow,distancename_mds,save_pass_mds)

%% 距離座標算出
distance=zeros(length(Onelow(:,1)));

for i=1:length(Onelow(:,1))
    for j=1:length(Onelow(:,1))
        
         distance(i,j)=pdist2(Onelow(i,:),Onelow(j,:),distancename_mds);
         %１から引く距離計量の時はコメントアウト
         if distance(i,j)>1
             distance(i,j)=1;
         end
         if i==j
              distance(i,j)=0;
         end       
    end
end

Coordinates = mdscale(distance,2);
Coordinates3 = mdscale(distance,3);

%% stress値算出
stressvalue=[];

for i=1:10
    [testCoordinates,stress] = mdscale(distance,i);
    stressvalue=vertcat(stressvalue,horzcat(i,stress));
end

save(char(fullfile(save_pass_mds,'stress.mat')),'stressvalue');

end