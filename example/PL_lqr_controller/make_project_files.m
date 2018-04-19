%% Make the project template
% Note, this command is desctructive to the source code, so back-up the source
% code and then merge the code into the new source tree if this command is
% used.

% x0 is a 6 element array, fixed point, 8 integer bits and 16 fraction bits
% x_ref is a 6 element array, fixed point, 8 integer bits and 16 fraction bits
% u is a 3 element array, fixed point, 8 integer bits and 16 fraction bits
make_template('type','PL','project_name','lqr_controller','input','x0:6:fix:8:16','input','x_ref:6:fix:8:16','output','u:3:fix:8:16')