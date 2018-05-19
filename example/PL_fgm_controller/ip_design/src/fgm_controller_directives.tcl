# ################################################################## 
# Directives used by Vivado HLS project fgm_controller

# DDR3 memory m_axi interface directives
set_directive_interface -mode m_axi -depth 81 "foo" memory_inout

# IP core handling directives
set_directive_interface -mode s_axilite -bundle BUS_A "foo"

# Input vectors offset s_axilite interface directives
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_x_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_num_iter_in_offset

# Output vectors offset s_axilite interface directives
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_x_out_offset

set_directive_inline -off "foo_user"

# pipeline the for loop named "input_cast_loop_*" in foo.cpp
set_directive_pipeline "foo/input_cast_loop_x"
set_directive_pipeline "foo/input_cast_loop_num_iter"
# pipeline the for loop named "output_cast_loop_*" in foo.cpp
set_directive_pipeline "foo/output_cast_loop_x"



