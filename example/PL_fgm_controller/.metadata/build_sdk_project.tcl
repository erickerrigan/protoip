# ##############################################################################################
# icl::protoip
# Author: asuardi <https://github.com/asuardi>
# Date: November - 2014
# ##############################################################################################



set workspace_name "workspace1"
set hdf "design_1_wrapper.hdf"

sdk set_workspace $workspace_name
sdk create_hw_project -name design_1_wrapper_hw_platform_1 -hwspec $hdf
sdk create_app_project -name test_fpga -proc ps7_cortexa9_0 -hwproject design_1_wrapper_hw_platform_1 -lang C  -app {lwIP Echo Server}

# added by Bulat
sdk configapp -app test_fpga build-config Release
# end added by Bulat

file copy -force ../../../src/echo.c workspace1/test_fpga/src
file copy -force ../../../src/main.c workspace1/test_fpga/src
file copy -force ../../../src/FPGAserver.h workspace1/test_fpga/src

sdk build_project -type all
