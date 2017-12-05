%% Setup the MATLAB path to contain the proper folders for ProtoIP

% Find out where the toolbox is
filename = [mfilename, '.m'];
scriptDir = which(filename);
scriptDir = strrep(scriptDir, filename, '');

% Add all subfolders to the path
addpath( genpath(scriptDir) );

% Remove the benchmark problems directory from the path
rmpath( genpath([scriptDir, filesep, 'example']) );

% Remove the variables used
clear filename scriptDir