%% Make the project template
% Note, this command is desctructive to the source code, so back-up the source
% code and then merge the code into the new source tree if this command is
% used.

% x is a 40 element array, fixed point, 8 integer bits and 16 fraction bits
% num_iter is a scalar, fixed point, 16 integer bits and 0 fraction bits
% x is a 40 element array, fixed point, 8 integer bits and 16 fraction bits
make_template('type','PL','project_name','fgm_controller','input','x:40:fix:8:16','input','num_iter:1:fix:16:0','output','x:40:fix:8:16')