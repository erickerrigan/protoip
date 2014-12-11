function [DOUBLE_J_cl,flag_simulation,xstore,ustore,ystore,regionstore]=double_simulation_explicit_controller(ctrl,Tsim,x_initialization)

%[nx, nu, ny] = mpt_sysStructInfo(ctrl.sysStruct);
nx=size(ctrl.sysStruct.B,1);
nu=size(ctrl.sysStruct.B,2);
G=ctrl.Gi;
F=ctrl.Fi;

% A=cell2mat(ctrl.sysStruct.A)
% B=cell2mat(ctrl.sysStruct.B)
% C=cell2mat(ctrl.sysStruct.C)
% D=cell2mat(ctrl.sysStruct.D)


A=(ctrl.sysStruct.A);
B=(ctrl.sysStruct.B);
C=(ctrl.sysStruct.C);
D=(ctrl.sysStruct.D);

Q=ctrl.probStruct.Q;
R=ctrl.probStruct.R;
P_N=ctrl.probStruct.P_N;

% [min_depth, max_depth, Nint] = searchTree_analysis(ctrl);
Ts =ctrl.sysStruct.Ts;



MAX_iterations=Tsim/Ts;



[m,n]=size(x_initialization);

for i=1:m

    %initialization values
    x0=x_initialization(i,:);

    J_cl=0;

    ystore=[];
    xstore=[];
    Jclstore=[];
    regionstore=[];
    ustore=[];
    
   for iter=1:MAX_iterations

       
        xstore=[xstore, x0'];
       
        [region_FIX, ~] = double_searchTree_point_location(ctrl,x0);
        tmp = double_control_law(F,G, x0, region_FIX);


        u=tmp(1:nu);

        %Apply plant dynamic and output noise

        x = A*x0'+B*u;
        y = C*x0'+D*u;
        
        x0 = x';


        % calculate infinite horizon closed-loop cost 
        J_cl_new = x'*Q*x + u'*R*u;
        J_cl = J_cl + J_cl_new;
        
        J_cl_final=x'*P_N*x;

        ystore=[ystore, y];
%         xstore=[xstore, x];
        Jclstore=[Jclstore, J_cl];
        regionstore=[regionstore, region_FIX];
        ustore=[ustore, u];
        
    end


    DOUBLE_J_cl_int(i)=J_cl+J_cl_final;
end

flag_simulation=1;
DOUBLE_J_cl=mean(DOUBLE_J_cl_int);
% DOUBLE_J_cl=0;

% if flag_constraints==0
%     J_cl=1e-15;
% end
% figure
% plot(Jclstore')
% figure
% plot(xstore')
% figure
% plot(ystore')
% figure
% stem(regionstore')
% figure
% plot(ustore')



 