function ip_design_test(varargin)

%%  Usage: ip_design_test
%  'project_name', 'value' - Project name
%                            It's a mandatory field
%  'num_test', value       - Number of test to run
%                            It's a mandatory field
%  'type_test', 'arg'      - Test(s) type: 
%                            'c' for C-simulation, 
%                            'xsim' for RTL-simulation via Xilinx Xsim, 
%                            'modelsim' for RTL-simulation via Menthor Graphics Modelsim
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
%  ['fclk ', value]        - Circuit clock frequency
%  ['FPGA_name', 'value']  - FPGA device name
 
% 
%   Description: 
%    Run a C/RTL simulation of the project named 'project_name' according to the 
%    specification in <WORKING DIRECTORY>/doc/project_name/ip_configuration_parameters.txt 
%    using Vivado HLS. 
%    
%    The specified inputs parameters overwrite the one specified into 
%    configuration parameters (doc/project_name/ip_configuration_parameters.txt).
% 
%   This command must be run only after 'make_template' command.
% 
%   Example:
%    ip_design_test('project_name','my_project0','type_test','c','num_test',1)
%    ip_design_test('project_name','my_project0','type_test','c','num_test',1,'input','x0:5:fix:10:10','input','x1:5:fix:10:10','output','y0:9:fix:9:9','fclk',133,'FPGA_name','xc7z020clg484-1')


%% call Matlab to Vivado interface file
tmp_cell = {mfilename};
matlab_vivado;


end

