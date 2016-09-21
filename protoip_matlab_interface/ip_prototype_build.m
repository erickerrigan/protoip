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


%% call Matlab to Vivado interface file
tmp_cell = {mfilename};
matlab_vivado;

%export timing, latency and resources information to Matlab workspace
%varargin=varargin{1,1};
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
str = strcat('doc/',project_name,'/ip_prototype.dat');
load(str);

assignin('base', 'Vivado_FPGA_target_clock_ns', ip_prototype(1));
assignin('base', 'Vivado_FPGA_achieved_clock_ns', ip_prototype(2));

assignin('base', 'Vivado_FPGA_pw_total_pr', ip_prototype(3));
assignin('base', 'Vivado_FPGA_pw_dyn_pr', ip_prototype(4));
assignin('base', 'Vivado_FPGA_pw_sta_pr', ip_prototype(5));
assignin('base', 'Vivado_IP_pw_total_pr', ip_prototype(6));
assignin('base', 'Vivado_user_function_pw_total_pr', ip_prototype(7));
assignin('base', 'Vivado_PS7_pw_total_pr', ip_prototype(8));

assignin('base', 'Vivado_FPGA_LUT_pr', ip_prototype(9));
assignin('base', 'Vivado_FPGA_FF_pr', ip_prototype(10));
assignin('base', 'Vivado_FPGA_RAMB_pr', ip_prototype(11));
assignin('base', 'Vivado_FPGA_DSP48_pr', ip_prototype(12));
assignin('base', 'Vivado_IP_LUT_pr', ip_prototype(13));
assignin('base', 'Vivado_IP_FF_pr', ip_prototype(14));
assignin('base', 'Vivado_IP_RAMB_pr', ip_prototype(15));
assignin('base', 'Vivado_IP_DSP48_pr', ip_prototype(16));
assignin('base', 'Vivado_user_function_LUT_pr', ip_prototype(17));
assignin('base', 'Vivado_user_function_FF_pr', ip_prototype(18));
assignin('base', 'Vivado_user_function_RAMB_pr', ip_prototype(19));
assignin('base', 'Vivado_user_function_DSP48_pr', ip_prototype(20));

assignin('base', 'Vivado_FPGA_LUT_synth', ip_prototype(21));
assignin('base', 'Vivado_FPGA_FF_synth', ip_prototype(22));
assignin('base', 'Vivado_FPGA_RAMB_synth', ip_prototype(23));
assignin('base', 'Vivado_FPGA_DSP48_synth', ip_prototype(24));
assignin('base', 'Vivado_IP_LUT_synth', ip_prototype(25));
assignin('base', 'Vivado_IP_FF_synth', ip_prototype(26));
assignin('base', 'Vivado_IP_RAMB_synth', ip_prototype(27));
assignin('base', 'Vivado_IP_DSP48_synth', ip_prototype(28));
assignin('base', 'Vivado_user_function_LUT_synth', ip_prototype(29));
assignin('base', 'Vivado_user_function_FF_synth', ip_prototype(30));
assignin('base', 'Vivado_user_function_RAMB_synth', ip_prototype(31));
assignin('base', 'Vivado_user_function_DSP48_synth', ip_prototype(32));

assignin('base', 'Vivado_FPGA_pw_total_synth', ip_prototype(33));
assignin('base', 'Vivado_FPGA_pw_dyn_synth', ip_prototype(34));
assignin('base', 'Vivado_FPGA_pw_sta_synth', ip_prototype(35));
assignin('base', 'Vivado_IP_pw_total_synth', ip_prototype(36));
assignin('base', 'Vivado_user_function_pw_total_synth', ip_prototype(37));
assignin('base', 'Vivado_PS7_pw_total_synth', ip_prototype(38));



end

