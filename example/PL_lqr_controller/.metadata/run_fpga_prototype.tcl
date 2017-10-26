# ##############################################################################################
# icl::protoip
# Author: asuardi <https://github.com/asuardi>
# Date: November - 2014
# ##############################################################################################



connect arm hw
rst
source workspace1/design_1_wrapper_hw_platform_1/ps7_init.tcl
ps7_init
fpga -f workspace1/design_1_wrapper_hw_platform_1/design_1_wrapper.bit
ps7_post_config
rst -processor
dow workspace1/test_fpga/Release/test_fpga.elf
run
