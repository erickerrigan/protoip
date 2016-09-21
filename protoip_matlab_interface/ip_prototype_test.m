function ip_prototype_test(varargin)

%%  Usage: ip_prototype_test
%   'project_name', 'value'   - Original project name to copy
%                               It's a mandatory field
%   'board_name', 'value'     - Evaluation board name
%                               It's a mandatory field
%   'num_test', 'value'       - Number of test(s)
%                               It's a mandatory field
%
%
%  Description: 
%   Run a HIL test of the IP prototype named 'project_name'
%    according to the project configuration parameters
%   [WORKING DIRECTORY]/doc/project_name/ip_configuration_parameters.txt
%   
%   An evaluation board connected to an host computer through an Ethernet cable is required.
%
%   This command must be run after 'ip_prototype_load' command only.
%
%  Example:
%   ip_prototype_test('project_name','my_project0','board_name','zedboard','num_test','1')


tmp_cell = {mfilename};
matlab_vivado;


end

