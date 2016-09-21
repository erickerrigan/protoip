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




%% call Matlab to Vivado interface file
tmp_cell = {mfilename};
matlab_vivado;



end

