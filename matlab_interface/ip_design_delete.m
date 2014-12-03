function ip_design_delete(varargin)

%%  Usage: ip_design_delete
%   'project_name', 'value' - Project name
%                             It's a mandatory field
% 
%  Description: 
%   Delete a project from [WORKING DIRECTORY]
% 
%  Example:
%   ip_design_delete('project_name','my_project0')


%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_delete function
str = which('ip_design_delete');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

