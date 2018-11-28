function [At,result]=optimization(C,w0,Xci,Xcj,param,source_train,target_train,x_target,c,Xtest,y)
        X_final=[source_train;x_target];
        data=[source_train;target_train];
        m1=size(source_train,1);
        m2=size(target_train,1);
        m3=size(Xtest,1);
        m4=size( X_final,1);
        uldata=Xtest;
        threshold=0.1;
        similarity=zeros(m3,c);
        omega=.5;
        eta=.5;
        classlist=unique(y);
        c=length(classlist);
        %% construct a similarity graph.
        SGraph=ConstructWeightedNNGraph(X_final,11);
        L=CalLaplacianMatrix(SGraph);
        clear sGraph;
       
        submeans=[];
        
        pi=1;
        for i=1:c
        index=find(y==classlist(i));    
        subdata=X_final(index,:);
        submean=Meanof1D(subdata);
        submeans=[submeans;submean];
        tmp=SGraph(index,(m1+m2+1):(m1+m2+m3));
        for j=1:m3
            
            tmpindex=find(tmp(:,j)>=threshold);
            if size(tmpindex,1)>0
                similarity(j,i)=mean(tmp(tmpindex,j));
            end
            clear tmpindex;
        end
        clear tmp index submean;
        end
    wth=pi*(uldata'*diag(sum(similarity'))*uldata+submeans'*diag(sum(similarity))*submeans-uldata'*similarity*submeans-submeans'*similarity'*uldata);
    LMSG=CalLaplacianMatrix(SGraph((m1+m2+1):(m1+m2+m3),(m1+m2+1):(m1+m2+m3)));
    clear SGraph DSGraph NNGraph;
    wth=wth+eta*uldata'*LMSG*uldata+omega*eye(size(data,2));

eplsion = param.eplsion;         
sigma = param.sigma;             
lamda=param.lamda; beta = param.beta;     
gamma=param.gamma; gammaW=param.gammaW/sigma;    
A0 = eye(size(Xci,2),size(Xci,2));
E=A0;
At = A0;
ns = size(source_train,1);    nt = size(target_train,1);
e = zeros(ns+nt,1);     e(1:ns,:) = 1;
w0 = w0(1:ns+nt,:); wt = w0;
iter=0;    convA=10000;
% tic
tic
while convA>eplsion && iter<100
    %% updata A
    sumA = zeros(size(Xci,2),size(Xci,2));
    pair_weights=wt(C(:,1),:).*wt(C(:,2),:).*C(:,3);
    for i=1:size(Xci,1)
        vij=Xci(i,:)-Xcj(i,:);
        % add 2C number of classes term and n
        sumA = sumA+A0*(vij'*vij)*pair_weights(i)*C(i,3)/((nt)*(nt-1));
       
    end
    %beta=10^3
    At = At-gamma*(beta*sumA+2*A0+10^-3*wth);
    %% updata omega
    zeta = zeros(ns+nt,1);
    for k=1:size(Xci,1)
        i = C(k,1); j=C(k,2); deta_ij = C(k,3);
        vij=Xci(k,:)-Xcj(k,:);  vijA = vij*At'; dij=vijA*vijA';
        zeta(i,1) = zeta(i,1)+wt(j)*(1-dij)*deta_ij;
        zeta(j,1) = zeta(j,1)+wt(i)*(1-dij)*deta_ij;
    end
    xi= sign(max(0,-wt));
    dev1 = 2*lamda*(wt-w0);
    dev2 = beta*zeta;
    
    dev3 = sigma*(2*(wt'*e-ns)*e+wt.*wt.*xi.*e);
    
    w_dev = dev1+dev2+dev3;
    wt = wt-gammaW*w_dev;     wt(ns+1:ns+nt,:) = 1;
    % wt = w0;
    %% compute threshold
    convA = norm(At-A0);
    convW = norm(wt-w0);
   A0=At;iter=iter+1;
 
end

end