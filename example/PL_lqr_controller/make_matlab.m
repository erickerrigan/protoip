%% to test the LQR algorithm with the HIL experimental setup, run from Matlab

ip_design_test('project_name','lqr_controller','type_test','c','num_test',1);
ip_design_test('project_name','lqr_controller','type_test','xsim','num_test',1);

ip_design_build('project_name','lqr_controller');

ip_prototype_build('project_name','lqr_controller','board_name','zedboard');
ip_prototype_load('project_name','lqr_controller','board_name','zedboard','type_eth','udp');
ip_prototype_test('project_name','lqr_controller','board_name','zedboard','num_test',1000);


%% plot closed-loop test states
load ip_prototype/test/results/lqr_controller/fpga_x0_in_log.dat
load ip_prototype/test/results/lqr_controller/matlab_x0_in_log.dat

subplot(2,1,1)
plot(fpga_x0_in_log)
title('LQR controller on FPGA (fixed-point 8 bits integer length, 16 bits fraction length)');
ylabel('states')
xlabel('step [k]')

subplot(2,1,2)
plot(matlab_x0_in_log)
title('LQR controller on host computer-Matlab (floating-point double precision)');
ylabel('states')
xlabel('step [k]')