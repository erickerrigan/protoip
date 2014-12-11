function [FIX_J_cl,flag_simulation,xstore,ustore,ystore,regionstore]=FIX_simulation_explicit_controller(ctrl,Tsim,bits,FIX_X1_FractionLength,FIX_H_FractionLength,FIX_K_FractionLength,FIX_X2_FractionLength,FIX_F_FractionLength,FIX_G_FractionLength,x_initialization)

%[H, K] = pelemfun(@double, ctrl.Pn);
G=ctrl.Gi;
F=ctrl.Fi;
Nr = length(ctrl.Pn);% number of regions
%[nx, nu, ny] = mpt_sysStructInfo(ctrl.sysStruct);
nx=size(ctrl.sysStruct.B,1);
nu=size(ctrl.sysStruct.B,2);

% A=cell2mat(ctrl.sysStruct.A);
% B=cell2mat(ctrl.sysStruct.B);
% C=cell2mat(ctrl.sysStruct.C);
% D=cell2mat(ctrl.sysStruct.D);


A=(ctrl.sysStruct.A);
B=(ctrl.sysStruct.B);
C=(ctrl.sysStruct.C);
D=(ctrl.sysStruct.D);

Q=ctrl.probStruct.Q;
R=ctrl.probStruct.R;
P_N=ctrl.probStruct.P_N;

% [min_depth, max_depth, Nint] = searchTree_analysis(ctrl);
Ts =ctrl.sysStruct.Ts;

xmax=[ ctrl.sysStruct.xmax, ctrl.sysStruct.xmin];
ymax=[ ctrl.sysStruct.ymax, ctrl.sysStruct.ymin];
%compute Integer Length
FIX_X1_IntegerLength=bits(1)-FIX_X1_FractionLength;
FIX_X2_IntegerLength=bits(2)-FIX_X2_FractionLength;
FIX_F_IntegerLength=bits(3)-FIX_F_FractionLength;
FIX_G_IntegerLength=bits(4)-FIX_G_FractionLength;
FIX_H_IntegerLength=bits(5)-FIX_H_FractionLength;
FIX_K_IntegerLength=bits(6)-FIX_K_FractionLength;


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

            [region_FIX, ~] =tree_FIX_point_location(ctrl, x0, FIX_X1_FractionLength,FIX_X1_IntegerLength,FIX_H_FractionLength,FIX_H_IntegerLength,FIX_K_FractionLength,FIX_K_IntegerLength);
%            [region_FIX, ~] = double_searchTree_point_location(ctrl,x0);
            if region_FIX==0
                fprintf('Double: Infeasible problem @ test %d, iteration %d, fraction lenght !\n',test,iter,FractionLength);
            end

            [tmp_u, tmp_x] = FIX_control_law(ctrl,F,G, x0, region_FIX, FIX_X2_FractionLength,FIX_X2_IntegerLength,FIX_F_FractionLength,FIX_F_IntegerLength,FIX_G_FractionLength,FIX_G_IntegerLength);
            u=tmp_u(1:nu);
            
            
            xstore=[xstore, tmp_x'];


            %Apply plant dynamic
            x = A*x0'+B*u;
            y = C*x0'+D*u;
            
            %Apply plant dynamic
%             x = A*tmp_x'+B*u;
%             y = C*tmp_x'+D*u;


            x0 = x';



            % calculate infinite horizon closed-loop cost 
            J_cl_new = x'*Q*x + u'*R*u;
            J_cl = J_cl + J_cl_new;

            J_cl_final=x'*P_N*x;
            

            ystore=[ystore, y];
%             xstore=[xstore, x];
%             Jclstore=[Jclstore, J_cl_new];
            Jclstore=[Jclstore, J_cl];
            regionstore=[regionstore, region_FIX];
            ustore=[ustore, u];


    end
    FIX_J_cl_int(i)=J_cl+J_cl_final;
end

flag_simulation=1;
FIX_J_cl=mean(FIX_J_cl_int);

% if flag_constraints==0
%     J_cl=1e-15;
% end


% figure
% hold on
% plot(Jclstore')
% figure
% plot(xstore')
% figure
% plot(ystore')
% figure
% stem(regionstore')
% figure
% plot(ustore')


% format long
% 
% xstore


 