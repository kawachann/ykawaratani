function [car1,car2]=getCars(log)

    %UDP通信の不具合（データのダブリを削除）---------------------------------------
    
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

    %ログが奇数なら最後の列削除-----------------------------------------------
    if mod(length(log),2)==1
        log(:,end)=[];
    end

    %ログデータのタイプ（二行目）から，自車（car1）と先行車（car2）のラベル指定--------------------
    
    if log(2,1)<log(2,2)
        car1=log(2,1);
        car2=log(2,2);
    else
        car1=log(2,2);
        car2=log(2,1);
    end

    %先行車と自車をわけわけ---------------------------------------------------------------
    
    if log(2,1)==car1
        car1=log(:,1:2:end);%自車
        car2=log(:,2:2:end);%先行車
    elseif log(2,1)==car2
        car1=log(:,2:2:end);
        car2=log(:,1:2:end);
    end
    
end