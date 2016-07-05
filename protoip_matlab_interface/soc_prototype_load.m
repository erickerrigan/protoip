function soc_prototype_load(varargin)

%%  Usage: ip_prototype_load
%   'project_name', 'value'   - Original project name to copy
%                               It's a mandatory field
%   'board_name', 'value'     - Evaluation board name
%                               It's a mandatory field
% 'type_eth', 'value'         - Ethernet connection protocol 
%                               ('udp' for UDP-IP connection or 'tcp' for TCP-IP connection)
%                               It's a mandatory field
% ['mem_base_address', 'value'] - DDR3 memory base address

%  Description: 
%   Build the FPGA Ethernet server application using SDK according 
%   to the project configuration parameters
%   [WORKING DIRECTORY]/doc/project_name/ip_configuration_parameters.txt
%   and program the FPGA.
  
%   An evaluation board connected to an host computer through an Ethernet and USB JTAG cable is required.
 
%   This command can be run after 'ip_prototype_build' command only.

%  
%  Example:
%   ip_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp')
%   ip_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp','mem_base_address',33554432)


%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_delete function
str = which('soc_prototype_load');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

