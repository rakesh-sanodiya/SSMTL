function [accuracy]=SSMTL(Parameter,data)
% disp('Running CDML');
%% Parameterter
a=Parameter.a; b=Parameter.b;
num_constraints=Parameter.num_constraints;
k=Parameter.k;dim=Parameter.dim;
%% load data
X = [data.data.train.source;data.data.train.target];
y = [data.labels.train.source';data.labels.train.target'];
Y_train=data.labels.train.target';
Xtest = data.data.test.target;
ytest = data.labels.test.target';
classlist=unique(ytest);
c=length(classlist);

len=size(X,1);
Xr = [X;Xtest];
len1=size(Xr,1);
dim1=25;
%% projecting the High dimensional data to lower dimensional using PCA
reduced_X=PCA_reduce(Xr,dim1);

X=reduced_X(1:len,:);

Xtest=reduced_X(len+1:len1,:);

%% Compute weights
% disp('Compute weights');
train_sample_n = size(data.data.train.source);
target_sample_n = size(data.data.train.target);
x_source = X(1:train_sample_n,:);
x_target = [X(train_sample_n+1:train_sample_n+target_sample_n,:);Xtest];
[PE, wh_x_source,wh_x_re]=RuLSIF(x_target',x_source');
wh_x_target = zeros(1,size(Xtest,1))+1;
wh_x_source = [wh_x_source,wh_x_target];
%% Compute distance extremes
% disp('Compute distance extremes');
[l, u] = ComputeDistanceExtremes(X, a, b);
% Generate constraint point pairs
% disp('Generate constraint point pairs');
C = GetConstraints(y, num_constraints, l, u);
Xci = X(C(:,1),:); yci = y(C(:,1),:);
Xcj = X(C(:,2),:); ycj = y(C(:,2),:);
%% Optimization
% disp('Optimization');
d=size(X,2); p=num_constraints;
w0 = wh_x_source;
source_train = X(1:train_sample_n,:);
target_train = X(train_sample_n+1:train_sample_n+target_sample_n,:);
[A]=optimization(C,w0',Xci,Xcj,Parameter,source_train,target_train,x_target,c,Xtest,Y_train);
%% Prediction
preds = KNN(y, X, A, k, Xtest);
acc = sum(preds==ytest)/size(ytest,1);
accuracy=acc(1,1);
end