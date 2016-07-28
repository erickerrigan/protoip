function soc_prototype_load_debug(varargin)

%%  Usage: soc_prototype_load_debug
%   'project_name', 'value'   - Original project name to copy
%                               It's a mandatory field
%   'board_name', 'value'     - Evaluation board name
%                               It's a mandatory field
%
%
%  Description: 
%   Open SDK to debug user's code (from soc_user.c and soc_user.h files) and the the FPGA Ethernet server running on the FPGA ARM processor.
%  
%   This command must be run after 'soc_prototype_load' command only.
%  
%  Example:
%   soc_prototype_load_debug('project_name','my_project0','board_name','zedboard')



%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
str = which('soc_prototype_load_debug');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

