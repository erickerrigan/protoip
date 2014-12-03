function ip_design_test_debug(varargin)

%%  Usage: ip_design_test_debug
%   'project_name', 'value' - Project name
%                             It's a mandatory field
%   'type_test', 'value'    - Test(s) type: 
%                             'c' for C-simulation, 
%                             'xsim' for RTL-simulation via Xilinx Xsim, 
%                             'modelsim' for RTL-simulation via Menthor Graphics Modelsim
%                             It's a mandatory field
% 
%  Description: 
%   Open the project named 'project_name' in the Vivado HLS GUI to debug a 
%   C/RTL simulation.
%   
%   This command can be run after 'ip_design_test' command only.
% 
% 
%   Example:
%    ip_design_build_debug('project_name', 'my_project0','type_test','c')


%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_test_debug function
str = which('ip_design_test_debug');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

