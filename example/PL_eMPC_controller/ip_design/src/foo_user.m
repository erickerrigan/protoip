%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% icl::protoip
% Author: asuardi <https://github.com/asuardi>
% Date: November - 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [u_out_int] = foo_user(project_name,x_in_int)



	% load project configuration parameters: input and output vectors (name, size, type, NUM_TEST, TYPE_TEST)
	load_configuration_parameters(project_name);

    addpath('functions');
    
    filename=strcat('eMPC_inverted_pendulum.mat');
    load(filename);

    nx=size(ctrl.sysStruct.B,1);
    nu=size(ctrl.sysStruct.B,2);
    G=ctrl.Gi;
    F=ctrl.Fi;

    A=(ctrl.sysStruct.A);
    B=(ctrl.sysStruct.B);
    C=(ctrl.sysStruct.C);
    D=(ctrl.sysStruct.D);
    
    x_in_int=x_in_int';
    
    [region, ~] = double_searchTree_point_location(ctrl,x_in_int);
	tmp = double_control_law(F,G, x_in_int, region);
	u_out_int=tmp(1:nu);


end

