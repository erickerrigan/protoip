for i=1:length(varargin)
	if (ischar(varargin{i}))
        tmp_cell = strcat(tmp_cell,{' '},varargin{i});
    else
    	tmp_cell = strcat(tmp_cell,{' '},num2str(varargin{i}));
    end
end
tmp_str = which('matlab_vivado');
tmp_str=tmp_str(1:end-2);
tmp_str=strcat(tmp_str,'.tcl');
system(sprintf('vivado -mode tcl -nolog -nojournal -source %s -tclargs %s', tmp_str, tmp_cell{:}));