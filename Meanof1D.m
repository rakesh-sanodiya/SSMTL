function result=Meanof1D(data)
    if size(data,1)==1
        result=data;
    else
        result=mean(data);
    end