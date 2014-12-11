############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 2014 Xilinx Inc. All rights reserved.
############################################################
set_directive_interface -mode m_axi -depth 81 "foo" memory_inout
set_directive_interface -mode s_axilite -bundle BUS_A "foo"
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_x_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_num_iter_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_x_out_offset
set_directive_pipeline "foo/input_cast_loop_x"
set_directive_pipeline "foo/input_cast_loop_num_iter"
set_directive_pipeline "foo/output_cast_loop_x"
set_directive_unroll "foo_user/user_init_loop"
set_directive_pipeline "foo_user/H_loop_row"
set_directive_unroll "foo_user/H_loop_dotproduct"
set_directive_unroll "foo_user/update_loop"
set_directive_array_reshape -type complete -dim 1 "foo_user" y











