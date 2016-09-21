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

%% call Matlab to Vivado interface file
tmp_cell = {mfilename};
matlab_vivado;

%export timing, resources and power information to Matlab workspace
%varargin=varargin{:};
nargin=length(varargin);
parameters=[];
values=[];
for i=1:2:nargin-1
    parameters=[parameters,varargin(i)];
    values=[values,varargin(i+1)];

end
 for i=1:length(parameters)
    if strcmp(parameters(i),'project_name')
        project_name=char(values(i));
    end
 end
str = strcat('doc/',project_name,'/ip_design.dat');
load(str);

assignin('base', 'Vivado_HLS_IP_target_clock_ns', ip_design(1));
assignin('base', 'Vivado_HLS_IP_estimated_clock_ns', ip_design(2));
assignin('base', 'Vivado_HLS_user_function_target_clock_ns', ip_design(3));
assignin('base', 'Vivado_HLS_user_function_estimated_clock_ns', ip_design(4));

assignin('base', 'Vivado_HLS_IP_latency_clk_cycles', ip_design(5));
assignin('base', 'Vivado_HLS_IP_latency_us', ip_design(6));
assignin('base', 'Vivado_HLS_user_function_latency_clk_cycles', ip_design(7));
assignin('base', 'Vivado_HLS_user_function_latency_us', ip_design(8));

assignin('base', 'Vivado_HLS_IP_BRAM_18K', ip_design(9));
assignin('base', 'Vivado_HLS_IP_DSP48E', ip_design(10));
assignin('base', 'Vivado_HLS_IP_FF', ip_design(11));
assignin('base', 'Vivado_HLS_IP_LUT', ip_design(12));
assignin('base', 'Vivado_HLS_user_function_BRAM_18K', ip_design(13));
assignin('base', 'Vivado_HLS_user_function_DSP48E', ip_design(14));
assignin('base', 'Vivado_HLS_user_function_FF', ip_design(15));
assignin('base', 'Vivado_HLS_user_function_LUT', ip_design(16));



end

