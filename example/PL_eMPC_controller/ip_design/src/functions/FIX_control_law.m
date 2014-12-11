function [u_out x_out] = FIX_control_law(ctrl,F,G, x, region, FIX_X_FractionLength,FIX_X_IntegerLength,FIX_F_FractionLength,FIX_F_IntegerLength,FIX_G_FractionLength,FIX_G_IntegerLength)

%[nx, nu, ny] = mpt_sysStructInfo(ctrl.sysStruct);
nx=size(ctrl.sysStruct.B,1);
nu=size(ctrl.sysStruct.B,2);

ProductWordLength=48;
SumWordLength=48;

%set fimath
Fix_math_control_law=fimath( 'RoundMode', 'Fix', ...
                                'OverflowMode', 'saturate', ...
                                'ProductMode', 'SpecifyPrecision', ...
                                'ProductWordLength', ProductWordLength, ...
                                'ProductFractionLength', FIX_X_FractionLength, ...
                                'SumMode', 'SpecifyPrecision', ...
                                'SumWordLength', SumWordLength, ...
                                'SumFractionLength', FIX_X_FractionLength, ...
                                'CastBeforeSum', true);

% Fix_math_control_law=fimath( 'RoundMode', 'Ceil', ...
%                                 'OverflowMode', 'saturate', ...
%                                 'ProductMode', 'FullPrecision', ...
%                                 'SumMode', 'FullPrecision');
                            
                        
                        
% FIX_X=fi(x, 1, FIX_X_IntegerLength+FIX_X_FractionLength, FIX_X_FractionLength);
% FIX_X.fimath=Fix_math_control_law;


for i=1:nx
    if x(i)<0
        FIX_X(i)=fi(abs(x(i)), 1, FIX_X_IntegerLength+FIX_X_FractionLength, FIX_X_FractionLength);
        FIX_X(i)=FIX_X(i)*(-1);
    else
        FIX_X(i)=fi(x(i), 1, FIX_X_IntegerLength+FIX_X_FractionLength, FIX_X_FractionLength);
    end
end

FIX_X.fimath=Fix_math_control_law;



% FIX_F=fi(cell2mat(F(region)), 1, FIX_F_IntegerLength+FIX_F_FractionLength, FIX_F_FractionLength);
% FIX_F.fimath=Fix_math_control_law;
TMP_F=cell2mat(F(region));
for i=1:nu
    for j=1:nx
        if TMP_F(i,j)<0
            FIX_F(i,j)=fi(abs(TMP_F(i,j)), 1, FIX_F_IntegerLength+FIX_F_FractionLength, FIX_F_FractionLength);
            FIX_F(i,j)=FIX_F(i,j)*(-1);
        else
            FIX_F(i,j)=fi(TMP_F(i,j), 1, FIX_F_IntegerLength+FIX_F_FractionLength, FIX_F_FractionLength);
        end
    end
end


FIX_F.fimath=Fix_math_control_law;
% 
% FIX_G=fi(cell2mat(G(region)), 1, FIX_G_IntegerLength+FIX_G_FractionLength, FIX_G_FractionLength);
% FIX_G.fimath=Fix_math_control_law;
TMP_G=cell2mat(G(region));
for i=1:nu
    if TMP_G(i)<0
        FIX_G(i)=fi(abs(TMP_G(i)), 1, FIX_G_IntegerLength+FIX_G_FractionLength, FIX_G_FractionLength);
        FIX_G(i)=FIX_G(i)*(-1);
    else
        FIX_G(i)=fi(TMP_G(i), 1, FIX_G_IntegerLength+FIX_G_FractionLength, FIX_G_FractionLength);
    end
end
FIX_G.fimath=Fix_math_control_law;


%% Arithmetic

FIX_U=FIX_F*FIX_X'+FIX_G;



u_out=double(FIX_U);
x_out=double(FIX_X);