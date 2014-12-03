function ip_prototype_load_debug(varargin)

%%  Usage: ip_prototype_load_debug
%   'project_name', 'value'   - Original project name to copy
%                               It's a mandatory field
%   'board_name', 'value'     - Evaluation board name
%                               It's a mandatory field
%
%
%  Description: 
%   Open SDK to debug the the FPGA Ethernet server running on the FPGA ARM processor.
%  
%   This command must be run after 'ip_prototype_load' command only.
%  
%  Example:
%   ip_prototype_load_debug('project_name','my_project0','board_name','zedboard')



%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_delete function
str = which('ip_prototype_load_debug');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

