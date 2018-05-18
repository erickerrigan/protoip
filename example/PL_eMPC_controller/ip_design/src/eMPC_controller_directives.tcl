# ################################################################## 
# Directives used by Vivado HLS project eMPC_controller

# DDR3 memory m_axi interface directives
set_directive_interface -mode m_axi -depth 3 "foo" memory_inout

# IP core handling directives
set_directive_interface -mode s_axilite -bundle BUS_A "foo"

# Input vectors offset s_axilite interface directives
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_x_in_offset

# Output vectors offset s_axilite interface directives
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_u_out_offset

set_directive_inline -off "foo_user"

# pipeline the for loop named "input_cast_loop_*" in foo.cpp
set_directive_pipeline "foo/input_cast_loop_x"
# pipeline the for loop named "output_cast_loop_*" in foo.cpp
set_directive_pipeline "foo/output_cast_loop_u"



