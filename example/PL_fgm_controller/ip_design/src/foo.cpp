/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"


void foo_user(  data_t_x_in x_in_int[X_IN_LENGTH],
				data_t_num_iter_in num_iter_in_int[NUM_ITER_IN_LENGTH],
				data_t_x_out x_out_int[X_OUT_LENGTH]);


void foo	(
				uint32_t byte_x_in_offset,
				uint32_t byte_num_iter_in_offset,
				uint32_t byte_x_out_offset,
				volatile data_t_memory *memory_inout)
{

	#ifndef __SYNTHESIS__
	//Any system calls which manage memory allocation within the system, for example malloc(), alloc() and free(), must be removed from the design code prior to synthesis. 

	data_t_interface_x_in *x_in;
	x_in = (data_t_interface_x_in *)malloc(X_IN_LENGTH*sizeof(data_t_interface_x_in));
	data_t_interface_num_iter_in *num_iter_in;
	num_iter_in = (data_t_interface_num_iter_in *)malloc(NUM_ITER_IN_LENGTH*sizeof(data_t_interface_num_iter_in));
	data_t_interface_x_out *x_out;
	x_out = (data_t_interface_x_out *)malloc(X_OUT_LENGTH*sizeof(data_t_interface_x_out));

	data_t_x_in *x_in_int;
	x_in_int = (data_t_x_in *)malloc(X_IN_LENGTH*sizeof (data_t_x_in));
	data_t_num_iter_in *num_iter_in_int;
	num_iter_in_int = (data_t_num_iter_in *)malloc(NUM_ITER_IN_LENGTH*sizeof (data_t_num_iter_in));
	data_t_x_out *x_out_int;
	x_out_int = (data_t_x_out *)malloc(X_OUT_LENGTH*sizeof (data_t_x_out));

	#else
	//for synthesis

	data_t_interface_x_in  x_in[X_IN_LENGTH];
	data_t_interface_num_iter_in  num_iter_in[NUM_ITER_IN_LENGTH];
	data_t_interface_x_out  x_out[X_OUT_LENGTH];

	static data_t_x_in  x_in_int[X_IN_LENGTH];
	static data_t_num_iter_in  num_iter_in_int[NUM_ITER_IN_LENGTH];
	data_t_x_out  x_out_int[X_OUT_LENGTH];

	#endif

	#if FLOAT_FIX_X_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_x_in_offset & (1<<31)))
	{
		memcpy(x_in,(const data_t_memory*)(memory_inout+byte_x_in_offset/4),X_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_x:for (int i=0; i< X_IN_LENGTH; i++)
			x_in_int[i]=(data_t_x_in)x_in[i];

	}
	

	#elif FLOAT_FIX_X_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_x_in_offset & (1<<31)))
	{
		memcpy(x_in_int,(const data_t_memory*)(memory_inout+byte_x_in_offset/4),X_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif


	#if FLOAT_FIX_NUM_ITER_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_num_iter_in_offset & (1<<31)))
	{
		memcpy(num_iter_in,(const data_t_memory*)(memory_inout+byte_num_iter_in_offset/4),NUM_ITER_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_num_iter:for (int i=0; i< NUM_ITER_IN_LENGTH; i++)
			num_iter_in_int[i]=(data_t_num_iter_in)num_iter_in[i];

	}
	

	#elif FLOAT_FIX_NUM_ITER_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_num_iter_in_offset & (1<<31)))
	{
		memcpy(num_iter_in_int,(const data_t_memory*)(memory_inout+byte_num_iter_in_offset/4),NUM_ITER_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif



	///////////////////////////////////////
	//USER algorithm function (foo_user.cpp) call
	//Input vectors are:
	//x_in_int[X_IN_LENGTH] -> data type is data_t_x_in
	//num_iter_in_int[NUM_ITER_IN_LENGTH] -> data type is data_t_num_iter_in
	//Output vectors are:
	//x_out_int[X_OUT_LENGTH] -> data type is data_t_x_out
	foo_user_top: foo_user(	x_in_int,
							num_iter_in_int,
							x_out_int);


	#if FLOAT_FIX_X_OUT == 1
	///////////////////////////////////////
	//store output vectors to memory (DDR)

	if(!(byte_x_out_offset & (1<<31)))
	{
		output_cast_loop_x: for(int i = 0; i <  X_OUT_LENGTH; i++)
			x_out[i]=(data_t_interface_x_out)x_out_int[i];

		//write results vector y_out to DDR
		memcpy((data_t_memory *)(memory_inout+byte_x_out_offset/4),x_out,X_OUT_LENGTH*sizeof(data_t_memory));

	}
	#elif FLOAT_FIX_X_OUT == 0
	///////////////////////////////////////
	//write results vector y_out to DDR
	if(!(byte_x_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_x_out_offset/4),x_out_int,X_OUT_LENGTH*sizeof(data_t_memory));
	}

	#endif




}
