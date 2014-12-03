function make_template(varargin)

%%  Usage: ip_design_build
%  'type', 'value'         - Template project type. 
%                            Now only a template with the algorithm running inside 
%                            the FPGA programmable logic is supported ('PL').
%                            It's a mandatory field
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
% 
%  Description: 
%   Build the IP prototype project template in the [WORKING DIRECTORY] 
%   according to the specified input and outputs vectors.
%   The project configuration parameters report is available in 
%   [WORKING DIRECTORY]/doc/project_name/ip_configuration_parameters.txt
%  
%  
% 
%  Example 1:
%   IP prototype with 2 inputs vectors: 
%   x0[10] fixed point (integer length 4 and fraction length 2)
%   x1[2] fixed point (integer length 6 and fraction length 2)
%   
%   1 output vector: 
%   y0[3] fixed point (integer length 3 and fraction length 2)
%   
%   make_template('type','PL','project_name','my_project0','input','x0:10:fix:4:2','input','x1:2:fix:6:2','output','y0:3:fix:3:2')
%   
%  Example 2:
%   IP prototype with 2 inputs vectors: 
%   x0[1] floating point
%   x1[2] floating point
%   
%   1 output vector: 
%   y0[4] floating point
%   
%   make_template('type','PL','project_name','my_project0','input','x0:1:float','input','x1:2:float','output','y0:4:float)


%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:make_template function
str = which('make_template');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

