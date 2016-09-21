function ip_prototype_load(varargin)

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


%% call Matlab to Vivado interface file
tmp_cell = {mfilename};
matlab_vivado;


end

