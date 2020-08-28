function locationplot(Coordinates,Coordinates3,entireRT,subN,save_pass_mds)

color=[[1,1,0];[1,1,0];[1,0,1];[1,0,1];[0,1,1];[0,1,1];[1,0,0];[1,0,0];[0,1,0];[0,1,0];[0,0,1];[0,0,1];[1,0.4,0.6];[1,0.4,0.6];[0,0,0];[0,0,0];[0,0.8,0.1];[0,0.8,0.1];[0.5,0.5,0.5];[0.5,0.5,0.5];[0.8,0.1,0.3];[0.8,0.1,0.3];[0.5,0,0.2];[0.5,0,0.2];[0.8,1,0.1];[0.8,1,0.1]]

%mds2次元
figure
for i=1:(length(subN)-1)*2
    if i==1
       sc1 = scatter(Coordinates(1:entireRT(1,1),1),Coordinates(1:entireRT(1,1),2),'o','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
       hold on 
    end
    
    if rem(i,2)==0
        sc1 = scatter(Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),'^','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
        hold on 
    end
    
     if rem(i,2)~=0&&i~=1
        sc1 = scatter(Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),'o','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
        OnTask=[];
        hold on 
     end
     
      if i==2
         subdaenlabel=Coordinates(1:entireRT(i-1)+entireRT(i),:);
         s1=cov(subdaenlabel);
         mu1=mean(subdaenlabel);
         q=95
         X1=daen(mu1,s1,q);
         sc1 = plot(X1(:,1),X1(:,2),'--','Color',[color(i,1),color(i,2),color(i,3)], 'LineWidth',1.5);
         hold on 
     end
     if rem(i,2)==0&&i~=2
         subdaenlabel=Coordinates(sum(entireRT(1:i-2))+1:sum(entireRT(1:i-2))+entireRT(i-1)+entireRT(i),:);
         s1=cov(subdaenlabel);
         mu1=mean(subdaenlabel);
         q=95;
         X1=daen(mu1,s1,q);
         sc1 = plot(X1(:,1),X1(:,2),'--','Color',[color(i,1),color(i,2),color(i,3)], 'LineWidth',1.5);
         hold on 
     end
     
end
xlabel('dimension1');
ylabel('dimension2');
hold off
saveas(sc1,fullfile(save_pass_mds,'indivi2'),'epsc');

%mds3次元
figure
for i=1:(length(subN)-1)*2
    if i==1
       sc1 = scatter3(Coordinates3(1:entireRT(1,1),1),Coordinates3(1:entireRT(1,1),2),Coordinates3(1:entireRT(1,1),1),'o','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
       hold on 
    end
    
    if rem(i,2)==0
        sc1 = scatter3(Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),3),'^','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
        hold on 
    end
    
     if rem(i,2)~=0&&i~=1
        sc1 = scatter3(Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),3),'o','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
         hold on 
     end
    
end
xlabel('dimension1');
ylabel('dimension2');
zlabel('dimension3');
hold off
saveas(sc1,fullfile(save_pass_mds,'indivi3'),'epsc');

%mds2次元（MW,OnTask）
OnTaskdaenlabel=[];
MWdaenlabel=[];
figure
for i=1:(length(subN)-1)*2
    if i==1
       sc1 = scatter(Coordinates(1:entireRT(1,1),1),Coordinates(1:entireRT(1,1),2),'o','MarkerEdgeColor','b');
       OnTaskdaenlabel=vertcat(OnTaskdaenlabel,Coordinates(1:entireRT(1,1),:));
       hold on 
    end
    
    if rem(i,2)==0
        sc1 = scatter(Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),'o','MarkerEdgeColor','r');
        MWdaenlabel=vertcat(MWdaenlabel,Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),:));
        hold on 
        
    end
    
     if rem(i,2)~=0&&i~=1
        sc1 = scatter(Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),'o','MarkerEdgeColor','b');
        OnTaskdaenlabel=vertcat(OnTaskdaenlabel,Coordinates(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),:));
         hold on 
     end
    
end
s1=cov(OnTaskdaenlabel);
mu1=mean(OnTaskdaenlabel);
s2=cov(MWdaenlabel);
mu2=mean(MWdaenlabel);
q=95;
X1=daen(mu1,s1,q);
X2=daen(mu2,s2,q);
sc1 = plot(X1(:,1),X1(:,2),'--','Color','b', 'LineWidth',1.5);
hold on 
sc1 = plot(X2(:,1),X2(:,2),'--','Color','r', 'LineWidth',1.5);
xlabel('dimension1');
ylabel('dimension2');
hold off
saveas(sc1,fullfile(save_pass_mds,'state2'),'epsc');

%mds3次元（MW,OnTask）
figure
for i=1:(length(subN)-1)*2
    if i==1
       sc1 = scatter3(Coordinates3(1:entireRT(1,1),1),Coordinates3(1:entireRT(1,1),2),Coordinates3(1:entireRT(1,1),3),'o','MarkerEdgeColor','b');
       hold on 
    end
    
    if rem(i,2)==0
        sc1 = scatter3(Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),3),'o','MarkerEdgeColor','r');
        hold on 
    end
    
     if rem(i,2)~=0&&i~=1
        sc1 = scatter3(Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),Coordinates3(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),3),'o','MarkerEdgeColor','b');
         hold on 
     end
    
end
xlabel('dimension1');
ylabel('dimension2');
zlabel('dimension3');
hold off
saveas(sc1,fullfile(save_pass_mds,'state3'),'epsc');

% figure 
% %mds2次元
% sc1 = scatter(Coordinates(1:5,1),Coordinates(1:5,2),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter(Coordinates(6:11,1),Coordinates(6:11,2),'^','MarkerEdgeColor','r');
% hold on
% sc3 = scatter(Coordinates(12:16,1),Coordinates(12:16,2),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter(Coordinates(17:21,1),Coordinates(17:21,2),'^','MarkerEdgeColor','b');
% hold on
% sc2 = scatter(Coordinates(22:26,1),Coordinates(22:26,2),'o','MarkerEdgeColor','g');
% hold on
% sc3 = scatter(Coordinates(27:31,1),Coordinates(27:31,2),'^','MarkerEdgeColor','g');
% hold on
% sc1 = scatter(Coordinates(32:36,1),Coordinates(32:36,2),'o','MarkerEdgeColor','y');
% hold on
% sc2 = scatter(Coordinates(37:41,1),Coordinates(37:41,2),'^','MarkerEdgeColor','y');
% hold on
% sc3 = scatter(Coordinates(42:46,1),Coordinates(42:46,2),'o','MarkerEdgeColor','m');
% hold on
% sc1 = scatter(Coordinates(47:51,1),Coordinates(47:51,2),'^','MarkerEdgeColor','m');
% hold on
% sc2 = scatter(Coordinates(52:56,1),Coordinates(52:56,2),'o','MarkerEdgeColor','c');
% hold on
% sc3 = scatter(Coordinates(57:61,1),Coordinates(57:61,2),'^','MarkerEdgeColor','c');
% hold on
% sc1 = scatter(Coordinates(62:67,1),Coordinates(62:67,2),'o','MarkerEdgeColor','w');
% hold on
% sc2 = scatter(Coordinates(68:73,1),Coordinates(68:73,2),'^','MarkerEdgeColor','w');
% hold on
% sc3 = scatter(Coordinates(74:78,1),Coordinates(74:78,2),'o','MarkerEdgeColor','k');
% hold on
% sc3 = scatter(Coordinates(79:83,1),Coordinates(79:83,2),'^','MarkerEdgeColor','k');
% hold on
% sc1 = scatter(Coordinates(84:88,1),Coordinates(84:88,2),'o','MarkerEdgeColor',[0,.5,0]);
% hold on
% sc2 = scatter(Coordinates(88:93,1),Coordinates(88:93,2),'^','MarkerEdgeColor',[0,.5,0]);
% hold off

% figure 
% mds2次元(MWとOnTask)
% sc1 = scatter(Coordinates(1:5,1),Coordinates(1:5,2),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter(Coordinates(6:11,1),Coordinates(6:11,2),'o','MarkerEdgeColor','b');
% hold on
% sc3 = scatter(Coordinates(12:16,1),Coordinates(12:16,2),'o','MarkerEdgeColor','r');
% hold on
% sc4 = scatter(Coordinates(17:21,1),Coordinates(17:21,2),'o','MarkerEdgeColor','b');
% hold on
% sc2 = scatter(Coordinates(22:26,1),Coordinates(22:26,2),'o','MarkerEdgeColor','r');
% hold on
% sc3 = scatter(Coordinates(27:31,1),Coordinates(27:31,2),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter(Coordinates(32:36,1),Coordinates(32:36,2),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter(Coordinates(37:41,1),Coordinates(37:41,2),'o','MarkerEdgeColor','b');
% hold on
% sc3 = scatter(Coordinates(42:46,1),Coordinates(42:46,2),'o','MarkerEdgeColor','r');
% hold on
% sc1 = scatter(Coordinates(47:51,1),Coordinates(47:51,2),'o','MarkerEdgeColor','b');
% hold on
% sc2 = scatter(Coordinates(52:56,1),Coordinates(52:56,2),'o','MarkerEdgeColor','r');
% hold on
% sc3 = scatter(Coordinates(57:61,1),Coordinates(57:61,2),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter(Coordinates(62:67,1),Coordinates(62:67,2),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter(Coordinates(68:73,1),Coordinates(68:73,2),'o','MarkerEdgeColor','b');
% hold on
% sc3 = scatter(Coordinates(74:78,1),Coordinates(74:78,2),'o','MarkerEdgeColor','r');
% hold on
% sc3 = scatter(Coordinates(79:83,1),Coordinates(79:83,2),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter(Coordinates(84:88,1),Coordinates(84:88,2),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter(Coordinates(88:93,1),Coordinates(88:93,2),'o','MarkerEdgeColor','b');
% hold off

% mds3次元
% figure
% sc1 = scatter3(Coordinates3(1:5,1),Coordinates3(1:5,2),Coordinates3(1:5,3),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter3(Coordinates3(6:11,1),Coordinates3(6:11,2),Coordinates3(6:11,3),'^','MarkerEdgeColor','r');
% hold on
% sc3 = scatter3(Coordinates3(12:16,1),Coordinates3(12:16,2),Coordinates3(12:16,3),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter3(Coordinates3(17:21,1),Coordinates3(17:21,2),Coordinates3(17:21,3),'^','MarkerEdgeColor','b');
% hold on
% sc2 = scatter3(Coordinates3(22:26,1),Coordinates3(22:26,2),Coordinates3(22:26,3),'o','MarkerEdgeColor','g');
% hold on
% sc3 = scatter3(Coordinates3(27:31,1),Coordinates3(27:31,2),Coordinates3(27:31,3),'^','MarkerEdgeColor','g');
% hold on
% sc1 = scatter3(Coordinates3(32:36,1),Coordinates3(32:36,2),Coordinates3(32:36,3),'o','MarkerEdgeColor','y');
% hold on
% sc2 = scatter3(Coordinates3(37:41,1),Coordinates3(37:41,2),Coordinates3(37:41,3),'^','MarkerEdgeColor','y');
% hold on
% sc3 = scatter3(Coordinates3(42:46,1),Coordinates3(42:46,2),Coordinates3(42:46,3),'o','MarkerEdgeColor','m');
% hold on
% sc1 = scatter3(Coordinates3(47:51,1),Coordinates3(47:51,2),Coordinates3(47:51,3),'^','MarkerEdgeColor','m');
% hold on
% sc2 = scatter3(Coordinates3(52:56,1),Coordinates3(52:56,2),Coordinates3(52:56,3),'o','MarkerEdgeColor','c');
% hold on
% sc3 = scatter3(Coordinates3(57:61,1),Coordinates3(57:61,2),Coordinates3(57:61,3),'^','MarkerEdgeColor','c');
% hold on
% sc1 = scatter3(Coordinates3(62:67,1),Coordinates3(62:67,2),Coordinates3(62:67,3),'o','MarkerEdgeColor','w');
% hold on
% sc2 = scatter3(Coordinates3(68:73,1),Coordinates3(68:73,2),Coordinates3(68:73,3),'^','MarkerEdgeColor','w');
% hold on
% sc3 = scatter3(Coordinates3(74:78,1),Coordinates3(74:78,2),Coordinates3(74:78,3),'o','MarkerEdgeColor','k');
% hold on
% sc3 = scatter3(Coordinates3(79:83,1),Coordinates3(79:83,2),Coordinates3(79:83,3),'^','MarkerEdgeColor','k');
% hold on
% sc1 = scatter3(Coordinates3(84:88,1),Coordinates3(84:88,2),Coordinates3(84:88,3),'o','MarkerEdgeColor',[0,.5,0]);
% hold on
% sc2 = scatter3(Coordinates3(88:93,1),Coordinates3(88:93,2),Coordinates3(88:93,3),'^','MarkerEdgeColor',[0,.5,0]);
% hold off

% % mds3次元(MWとOnTask)
% figure
% sc1 = scatter3(Coordinates3(1:5,1),Coordinates3(1:5,2),Coordinates3(1:5,3),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter3(Coordinates3(6:11,1),Coordinates3(6:11,2),Coordinates3(6:11,3),'o','MarkerEdgeColor','b');
% hold on
% sc3 = scatter3(Coordinates3(12:16,1),Coordinates3(12:16,2),Coordinates3(12:16,3),'o','MarkerEdgeColor','r');
% hold on
% sc1 = scatter3(Coordinates3(17:21,1),Coordinates3(17:21,2),Coordinates3(17:21,3),'o','MarkerEdgeColor','b');
% hold on
% sc2 = scatter3(Coordinates3(22:26,1),Coordinates3(22:26,2),Coordinates3(22:26,3),'o','MarkerEdgeColor','r');
% hold on
% sc3 = scatter3(Coordinates3(27:31,1),Coordinates3(27:31,2),Coordinates3(27:31,3),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter3(Coordinates3(32:36,1),Coordinates3(32:36,2),Coordinates3(32:36,3),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter3(Coordinates3(37:41,1),Coordinates3(37:41,2),Coordinates3(37:41,3),'o','MarkerEdgeColor','b');
% hold on
% sc3 = scatter3(Coordinates3(42:46,1),Coordinates3(42:46,2),Coordinates3(42:46,3),'o','MarkerEdgeColor','r');
% hold on
% sc1 = scatter3(Coordinates3(47:51,1),Coordinates3(47:51,2),Coordinates3(47:51,3),'o','MarkerEdgeColor','b');
% hold on
% sc2 = scatter3(Coordinates3(52:56,1),Coordinates3(52:56,2),Coordinates3(52:56,3),'o','MarkerEdgeColor','r');
% hold on
% sc3 = scatter3(Coordinates3(57:61,1),Coordinates3(57:61,2),Coordinates3(57:61,3),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter3(Coordinates3(62:67,1),Coordinates3(62:67,2),Coordinates3(62:67,3),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter3(Coordinates3(68:73,1),Coordinates3(68:73,2),Coordinates3(68:73,3),'o','MarkerEdgeColor','b');
% hold on
% sc3 = scatter3(Coordinates3(74:78,1),Coordinates3(74:78,2),Coordinates3(74:78,3),'o','MarkerEdgeColor','r');
% hold on
% sc3 = scatter3(Coordinates3(79:83,1),Coordinates3(79:83,2),Coordinates3(79:83,3),'o','MarkerEdgeColor','b');
% hold on
% sc1 = scatter3(Coordinates3(84:88,1),Coordinates3(84:88,2),Coordinates3(84:88,3),'o','MarkerEdgeColor','r');
% hold on
% sc2 = scatter3(Coordinates3(88:93,1),Coordinates3(88:93,2),Coordinates3(88:93,3),'o','MarkerEdgeColor','b');
% hold off



end