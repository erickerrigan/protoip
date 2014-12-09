
%% create 'matlab_interface' directory
mkdir('protoip_matlab_interface')


%% copy locally protoip matlab_interface from  https://github.com/asuardi/protoip repository
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_build.m', 'protoip_matlab_interface/ip_design_build.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_build.tcl', 'protoip_matlab_interface/ip_design_build.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_build_debug.m', 'protoip_matlab_interface/ip_design_build_debug.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_build_debug.tcl', 'protoip_matlab_interface/ip_design_build_debug.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_delete.m', 'protoip_matlab_interface/ip_design_delete.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_delete.tcl', 'protoip_matlab_interface/ip_design_delete.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_duplicate.m', 'protoip_matlab_interface/ip_design_duplicate.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_duplicate.tcl', 'protoip_matlab_interface/ip_design_duplicate.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_test.m', 'protoip_matlab_interface/ip_design_test.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_test.tcl', 'protoip_matlab_interface/ip_design_test.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_test_debug.m', 'protoip_matlab_interface/ip_design_test_debug.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_design_test_debug.tcl', 'protoip_matlab_interface/ip_design_test_debug.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_build.m', 'protoip_matlab_interface/ip_prototype_build.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_build.tcl', 'protoip_matlab_interface/ip_prototype_build.tcl');
pathtool
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_build_debug.m', 'protoip_matlab_interface/ip_prototype_build_debug.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_build_debug.tcl', 'protoip_matlab_interface/ip_prototype_build_debug.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_load.m', 'protoip_matlab_interface/ip_prototype_load.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_load.tcl', 'protoip_matlab_interface/ip_prototype_load.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_load_debug.m', 'protoip_matlab_interface/ip_prototype_load_debug.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_load_debug.tcl', 'protoip_matlab_interface/ip_prototype_load_debug.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_test.m', 'protoip_matlab_interface/ip_prototype_test.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/ip_prototype_test.tcl', 'protoip_matlab_interface/ip_prototype_test.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/make_configuration_parameters_matlab_interface.m', 'protoip_matlab_interface/make_configuration_parameters_matlab_interface.m');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/make_template.m', 'protoip_matlab_interface/make_template.m');
urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/make_template.tcl', 'protoip_matlab_interface/make_template.tcl');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/protoip_matlab_test.m', 'protoip_matlab_interface/protoip_matlab_test.m');

urlwrite('https://raw.githubusercontent.com/asuardi/protoip/master/protoip_matlab_interface/protoip_matlab_installer.tcl', 'protoip_matlab_interface/protoip_matlab_installer.tcl');

%% add matlab_interface folder to the path
path_to_add=(strcat('     ''',pwd,'\protoip_matlab_interface;'', '));
addpath(path_to_add);

source_file=which('pathdef.m');
fidr = fopen(source_file,'r');
path_already_exists=0;
while ( ~feof(fidr) )     
    str = fgets(fidr);                     
    U = strfind(str, 'protoip_matlab_interface'); 
    if isfinite(U) == 1;  
        path_already_exists=1;
        break; 
    end   
end
 

% if path doe not exist, add it to pathdef.m
if path_already_exists==0
    fidr = fopen(source_file,'r');
    fidw = fopen('pathdef_tmp.m','w');

    while ( ~feof(fidr) )     
        str = fgets(fidr);                     
        U = strfind(str, '%%% BEGIN ENTRIES %%%'); 
        if isfinite(U) == 1;  
            fwrite(fidw,str) ; 
            str = path_to_add;
            fwrite(fidw,str) ; 
        else
          fwrite(fidw,str) ;  
        end   
    end

    fclose(fidr);
    fclose(fidw);

    copyfile(destination_file,source_file,'f')
    delete('pathdef_tmp.m');
    
    tmp_str=strcat('''protoip_matlab_interface path'' added successfully');
    disp(tmp_str);
    
    
end
 


%% install protoip app. It is required xilinx Vivado software
str = strcat(pwd,'\protoip_matlab_interface\protoip_matlab_installer.tcl');
system(sprintf('vivado -mode tcl -source %s', str))

disp('protoip installed successfully')
