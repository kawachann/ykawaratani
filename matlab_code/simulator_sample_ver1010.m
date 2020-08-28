clear

% %被験者番号
% SubNo='8';

%mat存在ファイルの相対パス
filepath='../data/mat/';

%ファイル数を指定して各被験者データをセル配列に埋め込み
numfiles=10;
MatList={};
for ml=1:numfiles
    MatList=horzcat(MatList,horzcat('Subject',char(string(ml)),'.mat'));
end

ABT_List=zeros(1,length(MatList));
WBT_List=zeros(1,length(MatList));

%被験数分プログラムを回す
for n=1:length(MatList)
    
    load(horzcat(filepath,MatList{n}))

    %車両データ解析ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    log=DS;
    %各車両ログを抜き取り
    [car1,car2]=getCarslog(log);
    
    %%車両ログの中身
    % 1.Time
    % 2.ID　（自車か先行車か→数値の大きいほうが先行車）
    % 3.position X
    % 4.position Y
    % 5.speedInKmPerHour
    % 6.steering
    % 7.throttle
    % 8.brake

    %BRTの算出
    %BT（先行車がブレーキを踏んだ時間），RT（それに対するリアクションタイム）を抜き取り
    BRT=getBRT(car1,car2);

    %プレゼンテーションのログから注意と回答した時刻，ワンダリングと回答した時刻を抜き取り
    [AttentionT, WanderingT]=getSelfMind(Presen);

    %回答直前のBRTをとってくる作業ーーーーーーーーーーーーーーーーーーーーー
    BackTime=30; %直前をさかのぼる秒数（心電図の場合は３０S，脳なら１０S）
    [ABT, WBT]=getBRTatAW(AttentionT,WanderingT,BRT,BackTime);
    
    MedianABT=median(ABT);
    MedianWBT=median(WBT);
    
    ABT_List(n)=MedianABT;
    WBT_List(n)=MedianWBT;
    
end

[Sig_AWBT,Sig_AWBT_p]=ttest(ABT_List,WBT_List);