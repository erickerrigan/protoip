function ip_design_build(varargin)

%%  Usage: ip_design_build
%  'project_name', 'value' - Project name
%                            It's a mandatory field
%  ['input', 'value']      - Input vector name,size and type separated by : symbol
%                            Type can be: float or fix:xx:yy. 
%                            Where 'xx' is the integer length and 'yy' the 
%                            fraction length
%                            Repeat the command for every input vector to update
%                            All inputs and outputs must be of the same type: 
%                            float or fix
%  ['output', 'value']     - Output vector name,size and type separated by : symbol
%                            Type can be: float or fix:xx:yy. 
%                            Where 'xx' is the integer length and 'yy' the 
%                            fraction length
%                            Repeat the command for every output to update
%                            All inputs and outputs must be of the same type: 
%                            float or fix
%  ['fclk ', 'value']        - Circuit clock frequency
%  ['FPGA_name', 'value']  - FPGA device name
% 
%   Description: 
%    Build the IP XACT of the project named 'project_name' according to the 
%    specification in <WORKING DIRECTORY>/doc/project_name/ip_configuration_parameters.txt
%    using Vivado HLS. 
%    
%    The new specified inputs parameters overwrite 
%    the one specified into configuration parameters
%    [WORKING DIRECTORY]/doc/project_name/ip_configuration_parameters.txt.
%   
%    This command should be run after 'make_template' command only.
% 
%   Example:
%    ip_design_build('project_name','my_project0')
%    ip_design_build('project_name','my_project0','input','x0:5:fix:10:10','input','x1:5:fix:10:10','output','y0:9:fix:9:9','fclk', 133, 'FPGA_name', 'xc7z020clg484-1')

%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_build function
str = which('ip_design_build');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

