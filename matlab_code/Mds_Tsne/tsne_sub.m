function Loss_group_tsne=tsne_sub(substate,lowRT,highRT,subname,distancename_tsne,save_pass_tsne,Loss_group_tsne)
%% perplextiyê›íË
%2éüå≥
perplexitylabel2=[];

for i=5:length(substate(:,1))
[testCoordinates2,loss2]=tsne(substate,'Distance','correlation','Perplexity',i);
perplexitylabel2=vertcat(perplexitylabel2,horzcat(i,loss2));
end

[C2 I2]=min(perplexitylabel2(:,2))

%3éüå≥
perplexitylabel3=[];

for i=5:length(substate(:,1))
[testCoordinates3,loss3]=tsne(substate,'Distance','correlation','Perplexity',i);
perplexitylabel3=vertcat(perplexitylabel2,horzcat(i,loss3));
end

[C3 I3]=min(perplexitylabel3(:,2))

%% tsne
Coordinates2=tsne(substate,'Distance',distancename_tsne,'Exaggeration',10,'Perplexity',perplexitylabel2(I2,1));
Coordinates3=tsne(substate,'Distance',distancename_tsne,'NumDimensions',3,'Exaggeration',10,'Perplexity',perplexitylabel3(I3,1));

%% 2éüå≥plot
% figure 
% sc1 = scatter(Coordinates2(1:length(lowRT),1),Coordinates2(1:length(lowRT),2),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter(Coordinates2(length(lowRT)+1:length(lowRT)+length(highRT),1),Coordinates2(length(lowRT)+1:length(lowRT)+length(highRT),2),'o','MarkerEdgeColor','r');
% hold on 
% 
% %% ë»â~ï`é 
% s1=cov(Coordinates2(1:length(lowRT),:));
% mu1=mean(Coordinates2(1:length(lowRT),:));
% s2=cov(Coordinates2(length(lowRT)+1:length(lowRT)+length(highRT),:));
% mu2=mean(Coordinates2(length(lowRT)+1:length(lowRT)+length(highRT),:));
% q=95;
% X1=daen(mu1,s1,q);
% X2=daen(mu2,s2,q);
% sc1 = plot(X1(:,1),X1(:,2),'--','Color','b', 'LineWidth',1.5);
% hold on 
% sc1 = plot(X2(:,1),X2(:,2),'--','Color','r', 'LineWidth',1.5);
% xlabel('dimension1');
% ylabel('dimension2');
% hold off
% 
% %% ï€ë∂
% saveas(sc1,char(fullfile(save_pass_tsne,subname)),'epsc');
% 
% %% 3éüå≥plot
% figure 
% sc1 = scatter3(Coordinates3(1:length(lowRT),1),Coordinates3(1:length(lowRT),2),Coordinates3(1:length(lowRT),3),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter3(Coordinates3(length(lowRT)+1:length(lowRT)+length(highRT),1),Coordinates3(length(lowRT)+1:length(lowRT)+length(highRT),2),Coordinates3(length(lowRT)+1:length(lowRT)+length(highRT),3),'o','MarkerEdgeColor','r');
% hold on
% xlabel('dimension1');
% ylabel('dimension2');
% zlabel('dimension3');
% hold off
% 
% %% ï€ë∂
% saveas(sc1,char(fullfile(save_pass_tsne,strcat(subname,'_3'))),'epsc');

%% ê¸å`îªï ï™êÕ
Input_variable_2dimension=Coordinates2;
Input_variable_3dimension=Coordinates3;

testlabel=strings(length(lowRT)+length(highRT),1);
testlabel(1:length(lowRT),1)='OnTask';
testlabel(length(lowRT)+1:length(lowRT)+length(highRT),1)='MW';

Mdl_2dimension = fitcdiscr(Input_variable_2dimension,testlabel,'Leaveout','on','DiscrimType','pseudoQuadratic','HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus','Optimizer','bayesopt','OptimizeHyperparameters','auto'));
L2 = kfoldLoss(Mdl_2dimension);
Mdl_3dimension = fitcdiscr(Input_variable_3dimension,testlabel,'Leaveout','on','DiscrimType','pseudoQuadratic','HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus','Optimizer','bayesopt','OptimizeHyperparameters','auto'));
L3 = kfoldLoss(Mdl_3dimension);
Loss=[L2,L3];
Loss_group_tsne=vertcat(Loss_group_tsne,Loss)
%% ï€ë∂
save(char(fullfile(save_pass_tsne,strcat(subname,'_L.mat'))),'Loss');
end