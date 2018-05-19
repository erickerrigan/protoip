%% Make the project template
% Note, this command is desctructive to the source code, so back-up the source
% code and then merge the code into the new source tree if this command is
% used.

% x is a 2 element array, fixed point, 8 integer bits and 12 fraction bits
% u is a single element, fixed point, 8 integer bits and 12 fraction bits
make_template('type','PL','project_name','eMPC_controller','input','x:2:fix:8:12','output','u:1:fix:8:12')