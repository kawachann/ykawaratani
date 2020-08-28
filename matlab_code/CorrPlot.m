%���֐}���v���b�g���ĕԂ��֐�
%���́Fx,y�i���ꂼ��1�~����double�^�f�[�^�j�Cx�̎����x�����ichar�j�Cy�̎����x�����ichar�j,x���̃����W�z��Cy���̃����W�z��
%�o�́F���֐}�C���֌W���Cp�l

%*****boundedline.m��inpaint_nans.m���ꏏ�ɂ���********

%���������͂̎��̃����W�z��ɂ��ā�����
%������0,2,4,6,8,10�ɂ������ꍇ��xrange_vec=[0,2,10]  ���ݎw���^�񒆂ɓ���邱��
%�������ŏ�0�C�ő�10�ō��݂��w�肵�Ȃ��ꍇ��xrange_vec=[0,10]

%����C���Ƃ��v���b�g�̐F���T�C�Y���͂��̊֐��̒��g�𒼐ڕς��Ē���
function [f,r,p]=CorrPlot(x,y,xname,yname,xrange_vec,yrange_vec,s,t)

    %���֌W����p�l�Z�o
    [r,p]=corrcoef(x,y);
    
    data=sortrows([x',y']);

    %�U�z�}
    f=figure;
    plot(x,y,'o','MarkerSize',5,'MarkerEdgeColor',[0,0,0.9],'MarkerFaceColor',[0,0,0.9])
    ax=gca;

     %�ߎ������̕\��
    A = ones(length(data), 2);
    A(:, 1) = data(:,1);
    u = A\data(:,2);
    x2 = data(:,1);
    y2 = u(1) .* data(:,1) + u(2);
    hold on
    plot(x2, y2,'--','Color',[0,0,0],'LineWidth',1)
    
    %�M����Ԃ̕\��
    fitresult = fit(data(:,1), data(:,2),'poly1');
    pp = predint(fitresult,data(:,1),0.95,'functional');
    boundedline(x2,y2,pp(:,1)-y2,'cmap',[0,0,0],'alpha','transparency', 0.12,'--');

    %�e�p�����[�^�ݒ�-----------------------------------------
    %���̃T�C�Y
    ax.FontSize=20;
    ax.LineWidth=2.5;
    ax.FontName='Arial';

    %�e�������W�̒���
    if length(yrange_vec)==2
        ylim([yrange_vec(1) yrange_vec(2)])
    elseif length(yrange_vec)==3
        ylim([yrange_vec(1) yrange_vec(3)])
        yticks(yrange_vec(1):yrange_vec(2):yrange_vec(3))
    end
    ytickformat('%.1f');%�L������
    ylabel(yname,'FontSize',20)

    if length(xrange_vec)==2
        xlim([xrange_vec(1) xrange_vec(2)])
    elseif length(xrange_vec)==3
        xlim([xrange_vec(1) xrange_vec(3)])
        xticks(xrange_vec(1):xrange_vec(2):xrange_vec(3))
    end
    xlabel(xname,'FontSize',20)
    
    %�}��
   %legend(yname,horzcat(horzcat('r=',char(string(round(r(1,2),2,'significant')))),horzcat('  p=',char(string(round(p(2,1),2,'significant'))))))
    %legend(horzcat('r=',char(string(round(r(1,2),2)))))
    text(s,t,strcat(horzcat('r=',char(string(round(r(1,2),2,'significant')))),horzcat('  p=',char(string(round(p(2,1),2,'significant'))))),'FontSize',16)
    f=gcf;
   % box off

end