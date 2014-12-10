%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% icl::protoip
% Author: asuardi <https://github.com/asuardi>
% Date: November - 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [u_out_int] = foo_user(project_name,x0_in_int, x_ref_in_int)


	% load project configuration parameters: input and output vectors (name, size, type, NUM_TEST, TYPE_TEST)
	load_configuration_parameters(project_name);
	load LQR_example.mat

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% compute with Matlab and save in a file simulation results u_out_int
	u_cmd=K0*(x0_in_int-x_ref_in_int);
    
    %saturation
    for i=1:length(u_cmd)
        if u_cmd(i)<u_min(i)
            u_cmd(i)=u_min(i);
        elseif u_cmd(i)>u_max(i)
            u_cmd(i)=u_max(i);
        end
    end
    
	u_out_int=u_cmd;

end

