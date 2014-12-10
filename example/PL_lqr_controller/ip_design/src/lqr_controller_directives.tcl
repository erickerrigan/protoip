############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 2014 Xilinx Inc. All rights reserved.
############################################################
set_directive_interface -mode m_axi -depth 15 "foo" memory_inout
set_directive_interface -mode s_axilite -bundle BUS_A "foo"
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_x0_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_x_ref_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_u_out_offset
set_directive_pipeline "foo/input_cast_loop_x0"
set_directive_pipeline "foo/input_cast_loop_x_ref"
set_directive_pipeline "foo/output_cast_loop_u"
set_directive_pipeline "foo_user/nu_loop"
set_directive_unroll "foo_user/nx_loop"














