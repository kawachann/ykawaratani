function Loss_group_mds=mds_sub(substate,lowRT,highRT,subname,distancename_mds,save_pass_mds,Loss_group_mds)
%% ãóó£éZèo
distance=zeros(length(substate(:,1)));

for i=1:length(substate(:,1))
    for j=1:length(substate(:,1))
        
        distance(i,j)=pdist2(substate(i,:),substate(j,:),distancename_mds);
       
        %1-à»äOÇÃãóó£åvó ÇÕÉRÉÅÉìÉg
         if distance(i,j)>1
             distance(i,j)=1;
         end
         if i==j
              distance(i,j)=0;
         end       
         
    end
end
%% mds
Coordinates2 = mdscale(distance,2);
Coordinates3 = mdscale(distance,3);

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
% q=95
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
% saveas(sc1,char(fullfile(save_pass_mds,subname)),'epsc');
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
% saveas(sc1,char(fullfile(save_pass_mds,strcat(subname,'_3'))),'epsc');

%% ê¸å`îªï 
Input_variable_2dimension=Coordinates2;
Input_variable_3dimension=Coordinates3;

testlabel=strings(length(lowRT)+length(highRT),1);
testlabel(1:length(lowRT),1)='OnTask';
testlabel(length(lowRT)+1:length(lowRT)+length(highRT),1)='MW';

%Mdl_2dimension = fitcdiscr(Input_variable_2dimension,testlabel,'Leaveout','on','DiscrimType','quadratic','HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus','Optimizer','bayesopt','OptimizeHyperparameters','auto'));
Mdl_2dimension = fitcdiscr(Input_variable_2dimension,testlabel,'Leaveout','on','DiscrimType','pseudoQuadratic');
L2 = kfoldLoss(Mdl_2dimension);
%Mdl_3dimension = fitcdiscr(Input_variable_3dimension,testlabel,'Leaveout','on','DiscrimType','quadratic','HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus','Optimizer','bayesopt','OptimizeHyperparameters','auto'));
Mdl_3dimension = fitcdiscr(Input_variable_3dimension,testlabel,'Leaveout','on','DiscrimType','pseudoQuadratic');
L3 = kfoldLoss(Mdl_3dimension);
Loss=[L2,L3];
Loss_group_mds=vertcat(Loss_group_mds,Loss);
%% ï€ë∂
save(char(fullfile(save_pass_mds,strcat(subname,'_L.mat'))),'Loss');
end