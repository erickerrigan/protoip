%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% icl::protoip
% Author: asuardi <https://github.com/asuardi>
% Date: November - 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [x_out_int] = foo_user(project_name,x_in_int, num_iter_in_int)


	% load project configuration parameters: input and output vectors (name, size, type, NUM_TEST, TYPE_TEST)
	load_configuration_parameters(project_name);

	load FGM_example.mat
	nx=size(A_d,1);
	nu=size(B_d,2);
    
    %% pre-process
	%(algorithm's steps that will be implemented on the CPU)
	Fxr=[Fx,Fr];                            % This can be precomputed
	invH0 = inv(H);                         % This can be precomputed
	dualH0 = Aineq*invH0*Aineq';            % This can be precomputed
	sh = diag(1./sqrt(sum(abs(dualH0),2))); % This can be precomputed
	dualH = sh*dualH0*sh;                   % This can be precomputed
	premat_xout = -invH0*Aineq'*sh;         % This can be precomputed
	premat_xr = -invH0*Fxr;                 % This can be precomputed

	
	 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% compute with Matlab and save in a file simulation results

        % Simulation results x_out
        %initialization
        x = zeros(size(dualH,1),1);
        y = x;


        %% process
        %(algorithm's steps that will be implemented on the FPGA)
        for k2=1:num_iter_in_int(1)

            % Cache previous value of x
            xprev = x;

            % Calculate gradient
            gradJ = dualH*y+x_in_int;

            % Update x (from preconditioning, the value "L" is zero)
            xtilde = y - gradJ;

            % Project onto feasible region
            for k3 = 1:size(x,1)
                x(k3) = xtilde(k3);
                if xtilde(k3) > bmax(k3)
                    x(k3) = bmax(k3); 
                end
                if xtilde(k3) < bmin(k3)
                    x(k3) = bmin(k3);
                end
            end


            % Calculate difference between x and xprev
            xdiff = x-xprev;


            % Update y
            y = x+beta_iter(k2)*xdiff;


        end

        x_out_int = x; %this will be read from the FPGA

end

