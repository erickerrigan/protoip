%% to test the LQR algorithm with the HIL experimental setup, run from Matlab

ip_design_test('project_name','lqr_controller','type_test','c','num_test',1);
ip_design_test('project_name','lqr_controller','type_test','xsim','num_test',1);

ip_design_build('project_name','lqr_controller');

ip_prototype_build('project_name','lqr_controller','board_name','zedboard');
ip_prototype_load('project_name','lqr_controller','board_name','zedboard','type_eth','udp');
ip_prototype_test('project_name','lqr_controller','board_name','zedboard','num_test',1000);
