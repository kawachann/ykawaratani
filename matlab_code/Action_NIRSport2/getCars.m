function [car1,car2]=getCars(log)

    %UDP�ʐM�̕s��i�f�[�^�̃_�u�����폜�j---------------------------------------
    
    ID=log(2,:);
    dob=[];
    for i=2:length(ID)
        if ID(i)==ID(i-1)
            dob=horzcat(dob,i);
        end
    end
    
    log(:,dob)=[];
%     for j=1:length(dob)
%         log(:,dob(j))=[];
%     end

    %���O����Ȃ�Ō�̗�폜-----------------------------------------------
    if mod(length(log),2)==1
        log(:,end)=[];
    end

    %���O�f�[�^�̃^�C�v�i��s�ځj����C���ԁicar1�j�Ɛ�s�ԁicar2�j�̃��x���w��--------------------
    
    if log(2,1)<log(2,2)
        car1=log(2,1);
        car2=log(2,2);
    else
        car1=log(2,2);
        car2=log(2,1);
    end

    %��s�ԂƎ��Ԃ��킯�킯---------------------------------------------------------------
    
    if log(2,1)==car1
        car1=log(:,1:2:end);%����
        car2=log(:,2:2:end);%��s��
    elseif log(2,1)==car2
        car1=log(:,2:2:end);
        car2=log(:,1:2:end);
    end
    
end