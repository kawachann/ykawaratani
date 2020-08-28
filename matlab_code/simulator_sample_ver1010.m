clear

% %�팱�Ҕԍ�
% SubNo='8';

%mat���݃t�@�C���̑��΃p�X
filepath='../data/mat/';

%�t�@�C�������w�肵�Ċe�팱�҃f�[�^���Z���z��ɖ��ߍ���
numfiles=10;
MatList={};
for ml=1:numfiles
    MatList=horzcat(MatList,horzcat('Subject',char(string(ml)),'.mat'));
end

ABT_List=zeros(1,length(MatList));
WBT_List=zeros(1,length(MatList));

%�팱�����v���O��������
for n=1:length(MatList)
    
    load(horzcat(filepath,MatList{n}))

    %�ԗ��f�[�^��́[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[
    log=DS;
    %�e�ԗ����O�𔲂����
    [car1,car2]=getCarslog(log);
    
    %%�ԗ����O�̒��g
    % 1.Time
    % 2.ID�@�i���Ԃ���s�Ԃ������l�̑傫���ق�����s�ԁj
    % 3.position X
    % 4.position Y
    % 5.speedInKmPerHour
    % 6.steering
    % 7.throttle
    % 8.brake

    %BRT�̎Z�o
    %BT�i��s�Ԃ��u���[�L�𓥂񂾎��ԁj�CRT�i����ɑ΂��郊�A�N�V�����^�C���j�𔲂����
    BRT=getBRT(car1,car2);

    %�v���[���e�[�V�����̃��O���璍�ӂƉ񓚂��������C�����_�����O�Ɖ񓚂��������𔲂����
    [AttentionT, WanderingT]=getSelfMind(Presen);

    %�񓚒��O��BRT���Ƃ��Ă����Ɓ[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[�[
    BackTime=30; %���O�������̂ڂ�b���i�S�d�}�̏ꍇ�͂R�OS�C�]�Ȃ�P�OS�j
    [ABT, WBT]=getBRTatAW(AttentionT,WanderingT,BRT,BackTime);
    
    MedianABT=median(ABT);
    MedianWBT=median(WBT);
    
    ABT_List(n)=MedianABT;
    WBT_List(n)=MedianWBT;
    
end

[Sig_AWBT,Sig_AWBT_p]=ttest(ABT_List,WBT_List);