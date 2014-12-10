# to test the LQR algorithm with the HIL experimental setup, run from Xilinx Vivado

tclapp::icl::protoip::make_rand_stimuli -project_name lqr_controller
tclapp::icl::protoip::ip_design_test -project_name lqr_controller  -type_test c
tclapp::icl::protoip::ip_design_test -project_name lqr_controller  -type_test xsim

tclapp::icl::protoip::ip_design_build -project_name lqr_controller

tclapp::icl::protoip::ip_prototype_build -project_name lqr_controller -board_name zedboard
tclapp::icl::protoip::ip_prototype_load -project_name lqr_controller -board_name zedboard
tclapp::icl::protoip::ip_prototype_test -project_name lqr_controller -board_name zedboard -num_test 1000