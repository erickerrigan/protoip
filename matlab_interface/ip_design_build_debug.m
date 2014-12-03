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


%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_build_debug function
str = which('ip_design_build_debug');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

