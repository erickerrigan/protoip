%% to test the eMPC algorithm with the HIL experimental setup, run from Matlab

ip_design_test('project_name','eMPC_controller','type_test','c');
ip_design_test('project_name','eMPC_controller','type_test','xsim');

ip_design_build('project_name','eMPC_controller');
ip_prototype_build('project_name','eMPC_controller','board_name','zedboard');

%% Download and run the project on the board
ip_prototype_load('project_name','eMPC_controller','board_name','zedboard','type_eth','udp');
ip_prototype_test('project_name','eMPC_controller','board_name','zedboard','num_test',200);


%% plot closed-loop test states
load ip_prototype/test/results/eMPC_controller/fpga_x_in_log.dat
load ip_prototype/test/results/eMPC_controller/matlab_x_in_log.dat

subplot(2,1,1)
plot(fpga_x_in_log)
title('eMPC controller on FPGA (fixed-point 8 bits integer length, 12 bits fraction length)');
ylabel('states')
xlabel('step [k]')

subplot(2,1,2)
plot(matlab_x_in_log)
title('eMPC controller on host computer-Matlab (floating-point double precision)');
ylabel('states')
xlabel('step [k]')