clear

%被験者番号
SubNo='2';

%mat存在ファイルの相対パス
filepath='../data/mat/';

load(horzcat(filepath,'subject',SubNo,'.mat'))

%%logの中身
% 1.Time
% 2.ID　（自車か先行車か→数値の大きいほうが先行車）
% 3.position X
% 4.position Y
% 5.speedInKmPerHour
% 6.steering
% 7.throttle
% 8.brake

log=DS;

%ログが奇数なら最後の列削除
if rem(length(log),2)==1
    log(:,end)=[];
end

%UDP通信の不具合（データのダブリを削除）
ID=log(2,:);
dob=[];
for i=2:length(ID)
    if ID(i)==ID(i-1)
        dob=horzcat(dob,i);
    end
end
for j=1:length(dob)
    log(:,dob(j))=[];
end

%ログデータのタイプ（二行目）から，自車（car1）と先行車（car2）のラベル指定
if log(2,1)<log(2,2)
    car1_label=log(2,1);
    car2_label=log(2,2);
else
    car1_label=log(2,2);
    car2_label=log(2,1);
end

%先行車と自車をわけわけ
if log(2,1)==car1_label
    car1=log(:,1:2:end);%自車
    car2=log(:,2:2:end);%先行車
elseif log(2,1)==car2_label
    car1=log(:,2:2:end);
    car2=log(:,1:2:end);
end

label1=[];
label2=[];
brake1=car1(8,:);
brake2=car2(8,:);

%先行車がブレーキを踏んでいないときの自車ブレーキは除去
for m=1:length(brake2)
    if brake2(m)==0 && brake1(m)>0
        brake1(m)=0;
    end
end

%ブレーキを踏んだ瞬間の時刻と反応時刻を抜き出し
for l=2:length(brake1)
    if brake1(l-1)==0 && brake1(l)>0
        label1=horzcat(label1,car1(1,l));
    elseif brake2(l-1)==0 && brake2(l)>0
        label2=horzcat(label2,car2(1,l));
    end
end

%先行車のブレーキ時刻とそれに対する反応時間
BRT=vertcat(label2,(label1-label2));

