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


%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_delete function
str = which('ip_prototype_test');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))

cd ip_design/src;
test_HIL(project_name)
cd ../..


end

