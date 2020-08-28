clear

%�팱�Ҕԍ�
SubNo='2';

%mat���݃t�@�C���̑��΃p�X
filepath='../data/mat/';

load(horzcat(filepath,'subject',SubNo,'.mat'))

%%log�̒��g
% 1.Time
% 2.ID�@�i���Ԃ���s�Ԃ������l�̑傫���ق�����s�ԁj
% 3.position X
% 4.position Y
% 5.speedInKmPerHour
% 6.steering
% 7.throttle
% 8.brake

log=DS;

%���O����Ȃ�Ō�̗�폜
if rem(length(log),2)==1
    log(:,end)=[];
end

%UDP�ʐM�̕s��i�f�[�^�̃_�u�����폜�j
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

%���O�f�[�^�̃^�C�v�i��s�ځj����C���ԁicar1�j�Ɛ�s�ԁicar2�j�̃��x���w��
if log(2,1)<log(2,2)
    car1_label=log(2,1);
    car2_label=log(2,2);
else
    car1_label=log(2,2);
    car2_label=log(2,1);
end

%��s�ԂƎ��Ԃ��킯�킯
if log(2,1)==car1_label
    car1=log(:,1:2:end);%����
    car2=log(:,2:2:end);%��s��
elseif log(2,1)==car2_label
    car1=log(:,2:2:end);
    car2=log(:,1:2:end);
end

label1=[];
label2=[];
brake1=car1(8,:);
brake2=car2(8,:);

%��s�Ԃ��u���[�L�𓥂�ł��Ȃ��Ƃ��̎��ԃu���[�L�͏���
for m=1:length(brake2)
    if brake2(m)==0 && brake1(m)>0
        brake1(m)=0;
    end
end

%�u���[�L�𓥂񂾏u�Ԃ̎����Ɣ��������𔲂��o��
for l=2:length(brake1)
    if brake1(l-1)==0 && brake1(l)>0
        label1=horzcat(label1,car1(1,l));
    elseif brake2(l-1)==0 && brake2(l)>0
        label2=horzcat(label2,car2(1,l));
    end
end

%��s�Ԃ̃u���[�L�����Ƃ���ɑ΂��锽������
BRT=vertcat(label2,(label1-label2));

