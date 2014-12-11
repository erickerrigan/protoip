function [FIX_X1_IntegerLength,FIX_X2_IntegerLength,FIX_F_IntegerLength,FIX_G_IntegerLength,FIX_H_IntegerLength,FIX_K_IntegerLength] = FIX_eMPC_quantizer(ctrl,xmax)


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %DEBUG
% clear all;
% clc;
% close all;
% 
% addpath( genpath('C:/mpt'), '-first');
% 
% load expc_alpha.mat;
% expc=expc_alpha;
% 
% FIX_X_FractionLength=6;
% FIX_F_FractionLength=4;
% FIX_G_FractionLength=4;
% FIX_H_FractionLength=2;
% FIX_K_FractionLength=4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[min_depth, max_depth] = searchTree_analysis(ctrl);
tree=ctrl.details.searchTree;
[nodes, n]=size(tree);


G=ctrl.Gi;
F=ctrl.Fi;
Nr = length(ctrl.Pn);% number of regions
%[nx, nu, ny] = mpt_sysStructInfo(ctrl.sysStruct);
nx=size(ctrl.sysStruct.B,1);
nu=size(ctrl.sysStruct.B,2);


%% x

%x range

clear b;
b=xmax;

   %Word Length analysis
    if max(abs(nonzeros(b))) > 1

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    elseif max(abs(nonzeros(b))) == 1

        bits_max_value=2;
        
    elseif max(abs(b)) == 0

        bits_max_value=0;

    else

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    end

   
    FIX_X1_IntegerLength=bits_max_value+1;
    FIX_X2_IntegerLength=bits_max_value+1;

 
    
   

%% G

for j=1:Nr
    gdouble_int=full(cell2mat(G(j)));
    gdouble(:,j)=gdouble_int(1:nu);
end

clear b;
b=gdouble;

   %Word Length analysis
    if max(abs(nonzeros(b))) > 1

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    elseif max(abs(nonzeros(b))) == 1

        bits_max_value=2;

    elseif max(abs(b)) == 0

        bits_max_value=0;
        
    else

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    end

     FIX_G_IntegerLength=bits_max_value+1;
 
    

%% F

for j=1:Nr
    fdouble_int=cell2mat(F(j));
    fdouble((j-1)*nu+1:(j-1)*nu+1+nu-1,:)=fdouble_int(1:nu,1:nx,1);
end


clear b;
b=fdouble;

   %Word Length analysis
    if max(abs(nonzeros(b))) > 1

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    elseif max(abs(nonzeros(b))) == 1

        bits_max_value=2;
        
     elseif max(abs(b)) == 0

        bits_max_value=0;

    else

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    end


    
   FIX_F_IntegerLength=bits_max_value+1;
 

%% H


hdouble=tree(:,1:nx);

clear b;
b=hdouble;

 %Word Length analysis
    if max(abs(nonzeros(b))) > 1

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    elseif max(abs(nonzeros(b))) == 1

        bits_max_value=2;
        
    elseif max(abs(b)) == 0

        bits_max_value=0;

    else

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    end

    
   FIX_H_IntegerLength=bits_max_value+1;
% FIX_H_IntegerLength=0;



%% K

kdouble=tree(:,nx+1);

clear b;
b=kdouble;


    %Word Length analysis
    if max(abs(nonzeros(b))) > 1

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    elseif max(abs(nonzeros(b))) == 1

        bits_max_value=2;
        
    elseif max(abs(b)) == 0

        bits_max_value=0;

    else

        bits_max_value=ceil(log2(max(abs(nonzeros(b)))))+1;

    end


    FIX_K_IntegerLength=bits_max_value+1; 
% FIX_K_IntegerLength=0;

 


    




