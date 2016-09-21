function ip_design_build_debug(varargin)

%%  Usage: ip_design_build_debug
%   'project_name', 'value' - Project name
%                             It's a mandatory field
% 
%   Description: 
%    Open the project named 'project_name' in the Vivado HLS GUI 
%    to debug the IP hardware design.
%   
%    This command must be run only after 'ip_design_build' command.
% 
% 
%   Example:
%    ip_design_build_debug('project_name', 'my_project0')


%% call Matlab to Vivado interface file
tmp_cell = {mfilename};
matlab_vivado;

end

