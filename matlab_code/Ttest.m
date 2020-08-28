function [h,p]=Ttest(A,B,NameA,NameB,Name_ylabel)
%% �O��l����
TF1=1;
TF2=1;
for i=1:3
TF1 = find(isoutlier(A,'quartiles'));
A(TF1)=[];
B(TF1)=[];
TF2 = find(isoutlier(B,'quartiles'));
A(TF2)=[];
B(TF2)=[];
    if TF1~=[]&TF2~=[]
      break
    end
end

%% ttest

[h,p] = ttest(A,B);

%% ���ʕ\��
figure
boxplot([A B],'labels',{NameA,NameB});
ylabel(Name_ylabel)
hold on
Y=vertcat(A,B);
X=[];
X=horzcat(repelem(1,length(A)),repelem(2,length(B)));
X=X';
x = beeswarm(X,Y,'dot_size',3);
hold off

%% ���ʕ\���iviolin�j
end