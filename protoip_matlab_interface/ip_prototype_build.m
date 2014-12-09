function ip_prototype_build(varargin)

%%  Usage: ip_prototype_build
%   'project_name', 'value'   - Original project name to copy
%                               It's a mandatory field
%   'board_name', 'value'     - Evaluation board name
%                               It's a mandatory field
% 
% 
%  Description: 
%   Build the IP prototype of the project named 'project_name' 
%   associated to the evaluation board name 'board_name'
%   according to the project configuration parameters
%   [WORKING DIRECTORY]/doc/project_name/ip_configuration_parameters.txt
% 
%   The specified inputs parameters overwrite the one specified into 
%   configuration parameters 
%   [WORKING DIRECTORY]/doc/project_name/ip_configuration_parameters.txt
%  
%   The board name must match the FPGA model. Please refer to 
%   [WORKING DIRECTORY]/doc/project_name/ip_configuration_parameters.txt
%   for a detailed description.
%   
%   IP prototype implementation report with resources utilization and power consumption 
%   is available in [WORKING DIRECTORY]/doc/project_name/ip_prototype.txt
%   
%   This command should be run after 'ip_design_build' command only.
% 
%  
%  Example:
%   ip_prototype_build('project_name','my_project0','board_name','zedboard')


%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_delete function
str = which('ip_prototype_build');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

