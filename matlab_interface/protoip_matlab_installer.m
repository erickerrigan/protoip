
%% create 'matlab_interface' directory
mkdir('matlab_interface')


%% copy locally protoip matlab_interface from  https://github.com/asuardi/protoip repository
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_build.m', 'matlab_interface/ip_design_build.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_build.tcl', 'matlab_interface/ip_design_build.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_build_debug.m', 'matlab_interface/ip_design_build_debug.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_build_debug.tcl', 'matlab_interface/ip_design_build_debug.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_delete.m', 'matlab_interface/ip_design_delete.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_delete.tcl', 'matlab_interface/ip_design_delete.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_duplicate.m', 'matlab_interface/ip_design_duplicate.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_duplicate.tcl', 'matlab_interface/ip_design_duplicate.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_test.m', 'matlab_interface/ip_design_test.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_test.tcl', 'matlab_interface/ip_design_test.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_test_debug.m', 'matlab_interface/ip_design_test_debug.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_design_test_debug.tcl', 'matlab_interface/ip_design_test_debug.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_build.m', 'matlab_interface/ip_prototype_build.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_build.tcl', 'matlab_interface/ip_prototype_build.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_build_debug.m', 'matlab_interface/ip_prototype_build_debug.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_build_debug.tcl', 'matlab_interface/ip_prototype_build_debug.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_load.m', 'matlab_interface/ip_prototype_load.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_load.tcl', 'matlab_interface/ip_prototype_load.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_load_debug.m', 'matlab_interface/ip_prototype_load_debug.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_load_debug.tcl', 'matlab_interface/ip_prototype_load_debug.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_test.m', 'matlab_interface/ip_prototype_test.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/ip_prototype_test.tcl', 'matlab_interface/ip_prototype_test.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/make_configuration_parameters_matlab_interface.m', 'matlab_interface/make_configuration_parameters_matlab_interface.m');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/make_template.m', 'matlab_interface/make_template.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/make_template.tcl', 'matlab_interface/make_template.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/protoip_matlab_test.m', 'matlab_interface/protoip_matlab_test.m');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/matlab_interface/protoip_matlab_installer.tcl', 'matlab_interface/protoip_matlab_installer.tcl');

%% add matlab_interface folder to the path
addpath(strcat(pwd,'\matlab_interface'));
savepath

%% install protoip app. It is required xilinx Vivado software
str = which('protoip_matlab_installer');
str=str(1:end-2);
str=strcat(str,'.tcl');
system(sprintf('vivado -mode tcl -source %s', str))


disp('protoip installed successfully')