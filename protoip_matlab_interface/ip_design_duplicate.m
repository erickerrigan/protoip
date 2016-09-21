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


%% call Matlab to Vivado interface file
tmp_cell = {mfilename};
matlab_vivado;


end

