function [Coordinates2,Coordinates4,perplexitylabel2,perplexitylabel4]=Tsne(Onelow,distancename_tsne)
perplexitylabel2=[];
perplexitylabel4=[];

for i=5:50
[testCoordinates2,loss2]=tsne(Onelow,'Distance','correlation','Perplexity',i);
perplexitylabel2=vertcat(perplexitylabel2,horzcat(i,loss2));

[testCoordinates4,loss4]=tsne(Onelow,'Distance','correlation','NumDimensions',3,'Perplexity',i);
perplexitylabel4=vertcat(perplexitylabel4,horzcat(i,loss4));
end

[C2 I2]=min(perplexitylabel2(:,2))
Coordinates2=tsne(Onelow,'Distance',distancename_tsne,'Perplexity',perplexitylabel2(I2,1),'Exaggeration',10);
[C4 I4]=min(perplexitylabel4(:,2))
Coordinates4=tsne(Onelow,'Distance',distancename_tsne,'NumDimensions',3,'Perplexity',perplexitylabel4(I4,1),'Exaggeration',10);

end