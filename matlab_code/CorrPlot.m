%相関図をプロットして返す関数
%入力：x,y（それぞれ1×ｎのdouble型データ），xの軸ラベル名（char），yの軸ラベル名（char）,x軸のレンジ配列，y軸のレンジ配列
%出力：相関図，相関係数，p値

%*****boundedline.mとinpaint_nans.mを一緒につかう********

%＊＊＊入力の軸のレンジ配列について＊＊＊
%ｘ軸を0,2,4,6,8,10にしたい場合→xrange_vec=[0,2,10]  刻み指定を真ん中に入れること
%ｘ軸を最小0，最大10で刻みを指定しない場合→xrange_vec=[0,10]

%現状，軸とかプロットの色やらサイズやらはこの関数の中身を直接変えて調整
function [f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t)

    %相関係数とp値算出
    [r,p]=corrcoef(x,y);
    
    data=sortrows([x',y']);

    %散布図
    f=figure;
    plot(x,y,'o','MarkerSize',5,'MarkerEdgeColor',[0,0,0.9],'MarkerFaceColor',[0,0,0.9])
    ax=gca;

     %近似直線の表示
    A = ones(length(data), 2);
    A(:, 1) = data(:,1);
    u = A\data(:,2);
    x2 = data(:,1);
    y2 = u(1) .* data(:,1) + u(2);
    hold on
    plot(x2, y2,'--','Color',[0,0,0],'LineWidth',1)
    
    %信頼区間の表示
    fitresult = fit(data(:,1), data(:,2),'poly1');
    pp = predint(fitresult,data(:,1),0.95,'functional');
    boundedline(x2,y2,pp(:,1)-y2,'cmap',[0,0,0],'alpha','transparency', 0.12,'--');

    %各パラメータ設定-----------------------------------------
    %軸のサイズ
    ax.FontSize=20;
    ax.LineWidth=2.5;
    ax.FontName='Arial';

    %各軸レンジの調整
    if length(yrange_vec)==2
        ylim([yrange_vec(1) yrange_vec(2)])
    elseif length(yrange_vec)==3
        ylim([yrange_vec(1) yrange_vec(3)])
        yticks(yrange_vec(1):yrange_vec(2):yrange_vec(3))
    end
    ytickformat('%.1f');%有効数字
    ylabel(yname,'FontSize',20)

    if length(xrange_vec)==2
        xlim([xrange_vec(1) xrange_vec(2)])
    elseif length(xrange_vec)==3
        xlim([xrange_vec(1) xrange_vec(3)])
        xticks(xrange_vec(1):xrange_vec(2):xrange_vec(3))
    end
    xlabel(xname,'FontSize',20)
    
    %凡例
   %legend(yname,horzcat(horzcat('r=',char(string(round(r(1,2),2,'significant')))),horzcat('  p=',char(string(round(p(2,1),2,'significant'))))))
    %legend(horzcat('r=',char(string(round(r(1,2),2)))))
    text(s,t,strcat(horzcat('r=',char(string(round(r(1,2),2,'significant')))),horzcat('  p=',char(string(round(p(2,1),2,'significant'))))),'FontSize',16)
    f=gcf;
   % box off

end