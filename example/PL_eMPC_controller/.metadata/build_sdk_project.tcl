# ##############################################################################################
# icl::protoip
# Author: asuardi <https://github.com/asuardi>
# Date: November - 2014
# ##############################################################################################



create_project -type hw -name design_1_wrapper_hw_platform_1 -hwspec design_1_wrapper.hdf
create_project -type app -name test_fpga -hwproject design_1_wrapper_hw_platform_1 -proc ps7_cortexa9_0 -os standalone -lang C -app {lwIP Echo Server} 

file copy -force ../../../src/echo.c test_fpga/src
file copy -force ../../../src/main.c test_fpga/src
file copy -force ../../../src/FPGAserver.h test_fpga/src

build -type all

exit
