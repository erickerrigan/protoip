function [region, FIX_X, node_list] = tree_FIX_point_location(ctrl, x, FIX_X_FractionLength,FIX_X_IntegerLength,FIX_H_FractionLength,FIX_H_IntegerLength,FIX_K_FractionLength,FIX_K_IntegerLength)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %DEBUG
% H=H_beta;
% K=K_beta;
% x=x_extended_beta;
% FIX_X_regions=FIX_X1_beta_regions;
% FIX_H_regions=FIX_H_beta_regions;
% FIX_K_regions=FIX_K_beta_regions;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


tree=ctrl.details.searchTree;


%[nx, nu, ny] = mpt_sysStructInfo(ctrl.sysStruct);
nx=size(ctrl.sysStruct.B,1);
nu=size(ctrl.sysStruct.B,2);


ProductWordLength=48;
SumWordLength=48;

%set fimath
Fix_math_point_location=fimath( 'RoundMode', 'Fix', ...
                                'OverflowMode', 'saturate', ...
                                'ProductMode', 'SpecifyPrecision', ...
                                'ProductWordLength', ProductWordLength, ...
                                'ProductFractionLength', FIX_X_FractionLength, ...
                                'SumMode', 'SpecifyPrecision', ...
                                'SumWordLength', SumWordLength, ...
                                'SumFractionLength', FIX_X_FractionLength, ...
                                'CastBeforeSum', true);



% FIX_X=fi(x, 1, FIX_X_IntegerLength+FIX_X_FractionLength, FIX_X_FractionLength);

for i=1:nx
    if x(i)<0
        FIX_X(i)=fi(abs(x(i)), 1, FIX_X_IntegerLength+FIX_X_FractionLength, FIX_X_FractionLength);
        FIX_X(i)=FIX_X(i)*(-1);
    else
        FIX_X(i)=fi(x(i), 1, FIX_X_IntegerLength+FIX_X_FractionLength, FIX_X_FractionLength);
    end
end

FIX_X.fimath=Fix_math_point_location;

node=1;
depth=0;

j=0;

node_list=[];

while (1)
    
    node_list=[node_list node];
    
    depth=depth+1;
    j=j+1;
    
    for i=1:nx
        if tree(node,i)<0
            FIX_H(i)=fi(abs(tree(node,i)), 1, FIX_H_IntegerLength+FIX_H_FractionLength, FIX_H_FractionLength);
            FIX_H(i)=FIX_H(i)*(-1);
        else
            FIX_H(i)=fi(tree(node,i), 1, FIX_H_IntegerLength+FIX_H_FractionLength, FIX_H_FractionLength);
        end
    end

    if tree(node,nx+1)<0
        FIX_K=fi(abs(tree(node,nx+1)), 1, FIX_K_IntegerLength+FIX_K_FractionLength, FIX_K_FractionLength);
        FIX_K=FIX_K*(-1);
    else
        FIX_K=fi(tree(node,nx+1), 1, FIX_K_IntegerLength+FIX_K_FractionLength, FIX_K_FractionLength);
    end
        
%     FIX_H=fi(tree(node,1:nx), 1, FIX_H_IntegerLength+FIX_H_FractionLength, FIX_H_FractionLength);
%     FIX_K=fi(tree(node,nx+1), 1, FIX_K_IntegerLength+FIX_K_FractionLength, FIX_K_FractionLength);


    
    
    
%     a=FIX_H*FIX_X'-FIX_K;
%     
%     if a<FIX_CONST
%         %on plus-side of the hyperplane
%         node=tree(node,nx+3);
%     else
%         %on minus-side of the hyperplane
%         node=tree(node,nx+2);
%     end

    if FIX_H*FIX_X'<FIX_K
        %on plus-side of the hyperplane
        node=tree(node,nx+3);
%         store_K(j,1)=double(FIX_K);
%         store_H(j,:)=double(FIX_H);
    else
        %on minus-side of the hyperplane
        node=tree(node,nx+2);
%         store_K(j,1)=-double(FIX_K);
%         store_H(j,:)=-double(FIX_H);
    end
    
    if node<0
%         depth
        break;
    end
    
end

% store_H
% store_K
% 
% 
% P = polytope(store_H,store_K);
% figure
% plot(P)
% figure
% mpt_plotArrangement(store_H,store_K);
% hold on
% plot(x(1),x(2),'*r')
% hold on
% plot(double(FIX_X(1)),double(FIX_X(2)),'*b')


region=-node;
