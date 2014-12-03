function ip_design_duplicate(varargin)

%%  Usage: ip_design_duplicate
%   'from', 'value'   - Original project name to copy
%                       It's a mandatory field
%   'to', 'value'     - New project name
%                       It's a mandatory field
% 
%  Description: Make a copy of a project in [WORKING DIRECTORY]
% 
%  Example:
%   ip_design_duplicate('from','project_name_original','to','project_name_new')


%% save temporary file with input arguments   
project_name=make_configuration_parameters_matlab_interface(varargin);
    
%call Vivado icl::protoip:ip_design_delete function
str = which('ip_design_duplicate');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


end

