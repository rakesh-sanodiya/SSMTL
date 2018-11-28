function [result,distance]=findKNN(dataset,data,K,varargin)
    if K>=size(dataset,1)
        result=1:size(dataset,1);
        distance=zeros(1,size(dataset,1));
        for i=1:size(dataset,1)
            distance(i)=sqrt(sum((dataset(i,:)-data).^2));
        end
        return;
    end
    distance=zeros(1,size(dataset,1));
    for i=1:size(dataset,1)
        distance(i)=sqrt(sum((dataset(i,:)-data).^2));
    end
    [distance,result]=sort(distance,2);
    if nargin==3||varargin{1}==0
        result=result(1:K);
        distance=distance(1:K);
    else
        result=result(2:(K+1));
        distance=distance(2:(K+1));
    end
    clear dataset;
    clear data;