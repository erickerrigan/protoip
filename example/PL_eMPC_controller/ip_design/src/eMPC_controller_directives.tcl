############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 2014 Xilinx Inc. All rights reserved.
############################################################
set_directive_interface -mode m_axi -depth 3 "foo" memory_inout
set_directive_interface -mode s_axilite -bundle BUS_A "foo"
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_x_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_u_out_offset
set_directive_pipeline "foo/input_cast_loop_x"
set_directive_pipeline "foo/output_cast_loop_u"
set_directive_unroll "foo_user/loop_dotproduct_F"
set_directive_pipeline "foo_user/loop_row_F"
set_directive_unroll "foo_user/loop_dotproduct_H"
set_directive_pipeline "foo_user/loop_row_H"




