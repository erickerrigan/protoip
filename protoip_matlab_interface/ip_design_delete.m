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


%% call Matlab to Vivado interface file
tmp_cell = {mfilename};
matlab_vivado;


end

