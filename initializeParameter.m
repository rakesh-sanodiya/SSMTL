function param = initializeParameter(Para)
% %   omeg eta  pi   alpha     k,	C,      dim,	sigma,	lamda,	beta,	gamma,	gammaW
%Para=[0.5, 0.5, 1,  1000,       1,   100,    100,     2,     1000,   1,      1e-4,   1e-5];

param.omega=Para(1);
param.eta=Para(2);
param.pi=Para(3);
param.alpha=Para(4);
param.k=Para(5);
param.num_constraints=Para(6);
param.dim=Para(7);
param.sigma = Para(8);             
param.lamda=Para(9);               
param.beta = Para(10);
param.gamma=Para(11);               
param.gammaW=Para(12);
param.a=5;
param.b=95;
param.eplsion=1e-7;             
end