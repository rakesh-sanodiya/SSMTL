function [result,scale]=ConstructWeightedNNGraph(data,K)
    n=size(data,1);
    NNlist=zeros(n,K);
    NNdist=zeros(n,K);
    scale=zeros(1,n);
    flag=zeros(n);
    for i=1:n
        [index,distance]=findKNN(data,data(i,:),K,1);
        NNlist(i,:)=index;
        NNdist(i,:)=distance;
        scale(i)=max(distance);
        clear distance;
        clear index;
    end
    result=zeros(n);
    for i=1:n
        if scale(i)==0
            continue;
        end
        for j=1:K
            t=NNlist(i,j);
            if flag(i,t)>0
                continue;
            end
            if flag(t,i)>0
                result(i,t)=result(t,i);
                flag(i,t)=1;
            else
                result(i,t)=exp(-NNdist(i,j)*NNdist(i,j)/(scale(i)*scale(t)));
                if isnan(result(i,t))
                    1;
                end
                result(t,i)=result(i,t);
                flag(i,t)=1;
                flag(t,i)=1;
            end
        end
    end
    clear flag;
    clear NNdist;
    clear NNlist;
    clear data;