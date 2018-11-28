function SSMTL_Demo
disp('Load different task of the datasets');
fileID = fopen('data.csv','w');
addpath('C:\Users\rakesh\Desktop\KBS\dataset')
dataset = {'29_to_07_3','29_to_27_3','29_to_09_3','29_to_05_3','07_to_05_3','07_to_27_3','07_to_29_3','07_to_09_3','09_to_07_3','09_to_05_3','09_to_27_3','09_to_29_3','05_to_29_3','05_to_09_3','05_to_27_3','05_to_07_3','W_to_D_3','W_to_C_3','W_to_A_3','A_to_W_3','A_to_D_3','A_to_C_3','C_to_A_3H','C_to_W_3H','C_to_D_3','D_to_C_3','D_to_A_3H','D_to_W_3H','USPS_vs_MNIST_ECML_5','MNIST_vs_USPS_ECML_5'}

%dataset = {'29_to_07_ECML_3','29_to_27_ECML_3','29_to_09_ECML_3','29_to_05_ECML_3','07_to_05_ECML_3','07_to_27_ECML_3','07_to_29_ECML_3','07_to_09_ECML_3','09_to_07_ECML_3','09_to_05_ECML_3','09_to_27_ECML_3','09_to_29_ECML_3','05_to_29_ECML_3','05_to_09_ECML_3','05_to_27_ECML_3','05_to_07_ECML_3','W_to_D_ECML_4','W_to_C_ECML_4','W_to_A_ECML_4','A_to_W_ECML_4','A_to_D_ECML_4','A_to_C_ECML_4','C_to_A_ECML_4H','C_to_W_ECML_4H','C_to_D_ECML_4','D_to_C_ECML_4','D_to_A_ECML_4H','D_to_W_ECML_4H','USPS_vs_MNIST_ECML_5','MNIST_vs_USPS_ECML_5'}
for idx = 1:numel(dataset)
  
data = load(char(dataset(idx)));
data.source_n = size(data.data.train.source,1);
data.target_train_n = size(data.data.train.target,1);
data.target_test_n = size(data.data.test.target,1);
data.dim = size(data.data.train.source,2);
% init parameters
disp('Init parameters...');
% %   omeg eta  pi   alpha     k,	C,      dim,	sigma,	lamda,	beta,	gamma,	gammaW
Para=[0.5, 0.5, 1,  1000,       1,   100,    100,     2,     1000,   1,      1e-4,   1e-5];
parameter = initializeParameter(Para);
% SSMTL
disp('Running Regularized metric...');
[acc]=SSMTL(parameter,data);
Can1=int2str(idx);
Can2=char(dataset(idx))
Can3=strcat(Can2,Can1);
Can=strcat(Can3,'.csv')
 nbytes = fprintf(fileID,'%5s %f \n',Can,acc)
end
fclose(fileID)
end