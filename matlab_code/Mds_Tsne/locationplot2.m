function locationplot2(Coordinates2,Coordinates4,entireRT,subN,save_pass_tsne)

color=[[1,1,0];[1,1,0];[1,0,1];[1,0,1];[0,1,1];[0,1,1];[1,0,0];[1,0,0];[0,1,0];[0,1,0];[0,0,1];[0,0,1];[1,0.4,0.6];[1,0.4,0.6];[0,0,0];[0,0,0];[0,0.8,0.1];[0,0.8,0.1];[0.5,0.5,0.5];[0.5,0.5,0.5];[0.8,0.1,0.3];[0.8,0.1,0.3];[0.5,0,0.2];[0.5,0,0.2];[0.8,1,0.1];[0.8,1,0.1]]

%tsne2次元
figure
for i=1:(length(subN)-1)*2
    if i==1
       sc1 = scatter(Coordinates2(1:entireRT(1,1),1),Coordinates2(1:entireRT(1,1),2),'o','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
       hold on 
    end
    
    if rem(i,2)==0
        sc1 = scatter(Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),'^','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
        hold on 
    end
    
     if rem(i,2)~=0&&i~=1
        sc1 = scatter(Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),'o','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
        OnTask=[];
        hold on 
     end
     if i==2
         subdaenlabel=Coordinates2(1:entireRT(i-1)+entireRT(i),:);
         s1=cov(subdaenlabel);
         mu1=mean(subdaenlabel);
         q=95;
         X1=daen(mu1,s1,q);
         sc1 = plot(X1(:,1),X1(:,2),'--','Color',[color(i,1),color(i,2),color(i,3)], 'LineWidth',1.5);
         hold on 
     end
     
     if rem(i,2)==0&&i~=2
         subdaenlabel=Coordinates2(sum(entireRT(1:i-2))+1:sum(entireRT(1:i-2))+entireRT(i-1)+entireRT(i),:);
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
saveas(sc1,fullfile(save_pass_tsne,'indivi2'),'epsc');


%tsne3次元
figure
for i=1:(length(subN)-1)*2
    if i==1
       sc1 = scatter3(Coordinates4(1:entireRT(1,1),1),Coordinates4(1:entireRT(1,1),2),Coordinates4(1:entireRT(1,1),3),'o','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
       hold on 
    end
    
    if rem(i,2)==0
        sc1 = scatter3(Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),3),'^','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
        hold on 
    end
    
     if rem(i,2)~=0&&i~=1
        sc1 = scatter3(Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),3),'o','MarkerEdgeColor',[color(i,1),color(i,2),color(i,3)]);
         hold on 
     end
end
xlabel('dimension1');
ylabel('dimension2');
zlabel('dimension3');
hold off
saveas(sc1,fullfile(save_pass_tsne,'indivi3'),'epsc');

%tsne2次元（MW,OnTask）
OnTaskdaenlabel=[];
MWdaenlabel=[];
figure
for i=1:(length(subN)-1)*2
    if i==1
       sc1 = scatter(Coordinates2(1:entireRT(1,1),1),Coordinates2(1:entireRT(1,1),2),'o','MarkerEdgeColor','b');
       OnTaskdaenlabel=vertcat(OnTaskdaenlabel,Coordinates2(1:entireRT(1,1),:));
       hold on 
    end
    
    if rem(i,2)==0
        sc1 = scatter(Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),'o','MarkerEdgeColor','r');
        MWdaenlabel=vertcat(MWdaenlabel,Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),:));
        hold on 
        
    end
    
     if rem(i,2)~=0&&i~=1
        sc1 = scatter(Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),'o','MarkerEdgeColor','b');
        OnTaskdaenlabel=vertcat(OnTaskdaenlabel,Coordinates2(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),:));
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
saveas(sc1,fullfile(save_pass_tsne,'state2'),'epsc');

%tsne3次元（MW,OnTask）
figure
for i=1:(length(subN)-1)*2
    if i==1
       sc1 = scatter3(Coordinates4(1:entireRT(1,1),1),Coordinates4(1:entireRT(1,1),2),Coordinates4(1:entireRT(1,1),3),'o','MarkerEdgeColor','b');
       hold on 
    end
    
    if rem(i,2)==0
        sc1 = scatter3(Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),3),'o','MarkerEdgeColor','r');
        hold on 
    end
    
     if rem(i,2)~=0&&i~=1
        sc1 = scatter3(Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),1),Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),2),Coordinates4(sum(entireRT(1:i-1))+1:sum(entireRT(1:i-1))+entireRT(i),3),'o','MarkerEdgeColor','b');
         hold on 
     end
    
end
xlabel('dimension1');
ylabel('dimension2');
zlabel('dimension3');
hold off
saveas(sc1,fullfile(save_pass_tsne,'state3'),'epsc');
end

