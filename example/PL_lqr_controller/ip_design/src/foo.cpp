/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"


void foo_user(  data_t_x0_in x0_in_int[X0_IN_LENGTH],
				data_t_x_ref_in x_ref_in_int[X_REF_IN_LENGTH],
				data_t_u_out u_out_int[U_OUT_LENGTH]);


void foo	(
				uint32_t byte_x0_in_offset,
				uint32_t byte_x_ref_in_offset,
				uint32_t byte_u_out_offset,
				volatile data_t_memory *memory_inout)
{

	#ifndef __SYNTHESIS__
	//Any system calls which manage memory allocation within the system, for example malloc(), alloc() and free(), must be removed from the design code prior to synthesis. 

	data_t_interface_x0_in *x0_in;
	x0_in = (data_t_interface_x0_in *)malloc(X0_IN_LENGTH*sizeof(data_t_interface_x0_in));
	data_t_interface_x_ref_in *x_ref_in;
	x_ref_in = (data_t_interface_x_ref_in *)malloc(X_REF_IN_LENGTH*sizeof(data_t_interface_x_ref_in));
	data_t_interface_u_out *u_out;
	u_out = (data_t_interface_u_out *)malloc(U_OUT_LENGTH*sizeof(data_t_interface_u_out));

	data_t_x0_in *x0_in_int;
	x0_in_int = (data_t_x0_in *)malloc(X0_IN_LENGTH*sizeof (data_t_x0_in));
	data_t_x_ref_in *x_ref_in_int;
	x_ref_in_int = (data_t_x_ref_in *)malloc(X_REF_IN_LENGTH*sizeof (data_t_x_ref_in));
	data_t_u_out *u_out_int;
	u_out_int = (data_t_u_out *)malloc(U_OUT_LENGTH*sizeof (data_t_u_out));

	#else
	//for synthesis

	data_t_interface_x0_in  x0_in[X0_IN_LENGTH];
	data_t_interface_x_ref_in  x_ref_in[X_REF_IN_LENGTH];
	data_t_interface_u_out  u_out[U_OUT_LENGTH];

	static data_t_x0_in  x0_in_int[X0_IN_LENGTH];
	static data_t_x_ref_in  x_ref_in_int[X_REF_IN_LENGTH];
	data_t_u_out  u_out_int[U_OUT_LENGTH];

	#endif

	#if FLOAT_FIX_X0_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_x0_in_offset & (1<<31)))
	{
		memcpy(x0_in,(const data_t_memory*)(memory_inout+byte_x0_in_offset/4),X0_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_x0:for (int i=0; i< X0_IN_LENGTH; i++)
			x0_in_int[i]=(data_t_x0_in)x0_in[i];

	}
	

	#elif FLOAT_FIX_X0_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_x0_in_offset & (1<<31)))
	{
		memcpy(x0_in_int,(const data_t_memory*)(memory_inout+byte_x0_in_offset/4),X0_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif


	#if FLOAT_FIX_X_REF_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_x_ref_in_offset & (1<<31)))
	{
		memcpy(x_ref_in,(const data_t_memory*)(memory_inout+byte_x_ref_in_offset/4),X_REF_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_x_ref:for (int i=0; i< X_REF_IN_LENGTH; i++)
			x_ref_in_int[i]=(data_t_x_ref_in)x_ref_in[i];

	}
	

	#elif FLOAT_FIX_X_REF_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_x_ref_in_offset & (1<<31)))
	{
		memcpy(x_ref_in_int,(const data_t_memory*)(memory_inout+byte_x_ref_in_offset/4),X_REF_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif



	///////////////////////////////////////
	//USER algorithm function (foo_user.cpp) call
	//Input vectors are:
	//x0_in_int[X0_IN_LENGTH] -> data type is data_t_x0_in
	//x_ref_in_int[X_REF_IN_LENGTH] -> data type is data_t_x_ref_in
	//Output vectors are:
	//u_out_int[U_OUT_LENGTH] -> data type is data_t_u_out
	foo_user_top: foo_user(	x0_in_int,
							x_ref_in_int,
							u_out_int);


	#if FLOAT_FIX_U_OUT == 1
	///////////////////////////////////////
	//store output vectors to memory (DDR)

	if(!(byte_u_out_offset & (1<<31)))
	{
		output_cast_loop_u: for(int i = 0; i <  U_OUT_LENGTH; i++)
			u_out[i]=(data_t_interface_u_out)u_out_int[i];

		//write results vector y_out to DDR
		memcpy((data_t_memory *)(memory_inout+byte_u_out_offset/4),u_out,U_OUT_LENGTH*sizeof(data_t_memory));

	}
	#elif FLOAT_FIX_U_OUT == 0
	///////////////////////////////////////
	//write results vector y_out to DDR
	if(!(byte_u_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_u_out_offset/4),u_out_int,U_OUT_LENGTH*sizeof(data_t_memory));
	}

	#endif




}
