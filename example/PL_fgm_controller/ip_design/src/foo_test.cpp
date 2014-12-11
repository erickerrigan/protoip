/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"



void foo	(	
				uint32_t byte_x_in_offset,
				uint32_t byte_num_iter_in_offset,
				uint32_t byte_x_out_offset,
				volatile data_t_memory *memory_inout);


using namespace std;
#define BUF_SIZE 64

//Input and Output vectors base addresses in the virtual memory
#define x_IN_DEFINED_MEM_ADDRESS 0
#define num_iter_IN_DEFINED_MEM_ADDRESS (X_IN_LENGTH)*4
#define x_OUT_DEFINED_MEM_ADDRESS (X_IN_LENGTH+NUM_ITER_IN_LENGTH)*4


int main()
{

	char filename[BUF_SIZE]={0};

    int max_iter;

	uint32_t byte_x_in_offset;
	uint32_t byte_num_iter_in_offset;
	uint32_t byte_x_out_offset;

	int32_t tmp_value;

	//assign the input/output vectors base address in the DDR memory
	byte_x_in_offset=x_IN_DEFINED_MEM_ADDRESS;
	byte_num_iter_in_offset=num_iter_IN_DEFINED_MEM_ADDRESS;
	byte_x_out_offset=x_OUT_DEFINED_MEM_ADDRESS;

	//allocate a memory named address of uint32_t or float words. Number of words is 1024 * (number of inputs and outputs vectors)
	data_t_memory *memory_inout;
	memory_inout = (data_t_memory *)malloc((X_IN_LENGTH+NUM_ITER_IN_LENGTH+X_OUT_LENGTH)*4); //malloc size should be sum of input and output vector lengths * 4 Byte

	FILE *stimfile;
	FILE * pFile;
	int count_data;


	float *x_in;
	x_in = (float *)malloc(X_IN_LENGTH*sizeof (float));
	float *num_iter_in;
	num_iter_in = (float *)malloc(NUM_ITER_IN_LENGTH*sizeof (float));
	float *x_out;
	x_out = (float *)malloc(X_OUT_LENGTH*sizeof (float));


	////////////////////////////////////////
	//read x_in vector

	// Open stimulus x_in.dat file for reading
	sprintf(filename,"x_in.dat");
	stimfile = fopen(filename, "r");

	// read data from file
	ifstream input1(filename);
	vector<float> myValues1;

	count_data=0;

	for (float f; input1 >> f; )
	{
		myValues1.push_back(f);
		count_data++;
	}

	//fill in input vector
	for (int i = 0; i<count_data; i++)
	{
		if  (i < X_IN_LENGTH) {
			x_in[i]=(float)myValues1[i];

			#if FLOAT_FIX_X_IN == 1
				tmp_value=(int32_t)(x_in[i]*(float)pow(2,(X_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_x_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_X_IN == 0
				memory_inout[i+byte_x_in_offset/4] = (float)x_in[i];
			#endif
		}

	}


	////////////////////////////////////////
	//read num_iter_in vector

	// Open stimulus num_iter_in.dat file for reading
	sprintf(filename,"num_iter_in.dat");
	stimfile = fopen(filename, "r");

	// read data from file
	ifstream input2(filename);
	vector<float> myValues2;

	count_data=0;

	for (float f; input2 >> f; )
	{
		myValues2.push_back(f);
		count_data++;
	}

	//fill in input vector
	for (int i = 0; i<count_data; i++)
	{
		if  (i < NUM_ITER_IN_LENGTH) {
			num_iter_in[i]=(float)myValues2[i];

			#if FLOAT_FIX_NUM_ITER_IN == 1
				tmp_value=(int32_t)(num_iter_in[i]*(float)pow(2,(NUM_ITER_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_num_iter_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_NUM_ITER_IN == 0
				memory_inout[i+byte_num_iter_in_offset/4] = (float)num_iter_in[i];
			#endif
		}

	}


	/////////////////////////////////////
	// foo c-simulation
	
	foo(	
				byte_x_in_offset,
				byte_num_iter_in_offset,
				byte_x_out_offset,
				memory_inout);
	
	
	/////////////////////////////////////
	// read computed x_out and store it as x_out.dat
	pFile = fopen ("x_out.dat","w+");

	for (int i = 0; i < X_OUT_LENGTH; i++)
	{

		#if FLOAT_FIX_X_OUT == 1
			tmp_value=*(int32_t*)&memory_inout[i+byte_x_out_offset/4];
			x_out[i]=((float)tmp_value)/(float)pow(2,(X_OUT_FRACTIONLENGTH));
		#elif FLOAT_FIX_X_OUT == 0
			x_out[i]=(float)memory_inout[i+byte_x_out_offset/4];
		#endif
		
		fprintf(pFile,"%f \n ",x_out[i]);

	}
	fprintf(pFile,"\n");
	fclose (pFile);
		

	return 0;
}
