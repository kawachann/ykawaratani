function [MWNIRS,OnTaskNIRS]=zchange(MWNIRS,OnTaskNIRS)
% label=0;
%  sumOnTask=[];
%  sumMW=[];
%  aveOnTask=[];
%  aveMW=[];
%  stdOnTask=[];
%  stdMW=[];
% for i=1:length(OnTaskNIRS)-1
%     for j=i+1:length(OnTaskNIRS)
%         
%       sumOnTask=horzcat(sumOnTask,OnTaskNIRS(i,j));  
%       sumMW=horzcat(sumMW,MWNIRS(i,j)); 
%       label=label+1;
%       
%     end
% end
% 
% aveOnTask=mean(sumOnTask);
% aveMW=mean(sumMW);
% stdOnTask=std(sumOnTask);
% stdMW=std(sumMW);
% 
% for i=1:length(OnTaskNIRS)-1
%     for j=i+1:length(OnTaskNIRS)
%         OnTaskNIRS(i,j)=(OnTaskNIRS(i,j)-aveOnTask)/stdOnTask;
%         MWNIRS(i,j)=(MWNIRS(i,j)-aveMW)/stdMW;
%     end
% end


MWNIRS=atanh(MWNIRS);
OnTaskNIRS=atanh(OnTaskNIRS);
end