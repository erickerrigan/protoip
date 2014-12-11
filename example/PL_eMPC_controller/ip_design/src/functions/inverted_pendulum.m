function [expc,ctrl,yinf,OS] = inverted_pendulum(fs,N,noise)


%%
yinf=0;% not used
OS=0;%not used


Ts=1/fs;


b = 0.48;
m=0.344; %[kg]
g=9.81; %[m/s2]
L=1.703; %[m]


Ac=[0, 1; g/L, -b/(m*L^2)];
Bc=[0; 1/(m*L^2)];
Cc=[1  0];
Dc=[0];

states = {'phi' 'phi_dot'};
inputs = {'u'};
outputs = {'phi'};

% continuous system
sysc=ss(Ac,Bc,Cc,Dc,'statename',states,'inputname',inputs,'outputname',outputs);

% continuous costs

Qc = [1 0 ; 0 1];%weights on states
Rc = 0.1; %weights on inputs

% discretize plant (need function sdlrq)
[K,Sd,~,Ad,Bd,Qd,Rd,Md] = sdlqr(Ac,Bc,Qc,Rc,zeros(size(Ac,2),size(Bc,2)),Ts);

Cd = Cc;
Dd = Dc;

% discretized system
sysd = ss(Ad,Bd,Cd,Dd,Ts);



%% Explicit MPC

%x(k+1)=Ax(k)+Bu(k)
sysStruct.A= Ad;
sysStruct.B= Bd;

%y(k)=Cx(k)+Du(k)
sysStruct.C= Cd;
sysStruct.D= Dd;


% constraints

%set constraints on states
sysStruct.xmin    =   [-pi; -pi/8];
sysStruct.xmax    =   [pi; pi/8];

%set constraints on inputs
sysStruct.umin    =   [-100];
sysStruct.umax    =   [100];

%and here are the weights
probStruct.Q=Qd; %weights on states
probStruct.R=Rd; %weights on inputs
probStruct.P_N=Sd;

sysStruct.noise = noise; %state disturbance


sysStruct.Ts=Ts;

probStruct.norm=2; %can be either 1 or Inf for linear performance index, or 2 for quadratic cost objective

probStruct.N=N;
probStruct.Nc=N;
probStruct.subopt_lev=0;

%built PWA controller with MPT toolbox
warning off;
expc = mpt_control(sysStruct, probStruct);
warning on;
%built search tree with MPT toolbox

Options.nu=m;
expc_simplified=mpt_simplify(expc, Options);
clear expc;
expc=expc_simplified;

ctrl=mpt_searchTree(expc);
    



