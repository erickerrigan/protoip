function ip_prototype_build_debug(varargin)

%%  Usage: ip_prototype_build_debug
%   'project_name', 'value'   - Original project name to copy
%                               It's a mandatory field
%   'board_name', 'value'     - Evaluation board name
%                               It's a mandatory field
% 
% 
%  Description: 
%   Open Vivado GUI to debug the project named 'project_name' 
%   associated to the evaluation board name 'board_name'
%   according to the project configuration parameters
%   [WORKING DIRECTORY]/doc/project_name/ip_configuration_parameters.txt
%  
% This command should be run after 'ip_prototype_build' command only.
%
%  Example:
%   ip_prototype_build_debug('project_name','my_project0','board_name','zedboard')



%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_delete function
str = which('ip_prototype_build_debug');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

