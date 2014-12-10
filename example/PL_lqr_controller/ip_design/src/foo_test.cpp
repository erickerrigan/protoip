/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"



void foo	(	
				uint32_t byte_x0_in_offset,
				uint32_t byte_x_ref_in_offset,
				uint32_t byte_u_out_offset,
				volatile data_t_memory *memory_inout);


using namespace std;
#define BUF_SIZE 64

//Input and Output vectors base addresses in the virtual memory
#define x0_IN_DEFINED_MEM_ADDRESS 0
#define x_ref_IN_DEFINED_MEM_ADDRESS (X0_IN_LENGTH)*4
#define u_OUT_DEFINED_MEM_ADDRESS (X0_IN_LENGTH+X_REF_IN_LENGTH)*4


int main()
{

	char filename[BUF_SIZE]={0};

    int max_iter;

	uint32_t byte_x0_in_offset;
	uint32_t byte_x_ref_in_offset;
	uint32_t byte_u_out_offset;

	int32_t tmp_value;

	//assign the input/output vectors base address in the DDR memory
	byte_x0_in_offset=x0_IN_DEFINED_MEM_ADDRESS;
	byte_x_ref_in_offset=x_ref_IN_DEFINED_MEM_ADDRESS;
	byte_u_out_offset=u_OUT_DEFINED_MEM_ADDRESS;

	//allocate a memory named address of uint32_t or float words. Number of words is 1024 * (number of inputs and outputs vectors)
	data_t_memory *memory_inout;
	memory_inout = (data_t_memory *)malloc((X0_IN_LENGTH+X_REF_IN_LENGTH+U_OUT_LENGTH)*4); //malloc size should be sum of input and output vector lengths * 4 Byte

	FILE *stimfile;
	FILE * pFile;
	int count_data;


	float *x0_in;
	x0_in = (float *)malloc(X0_IN_LENGTH*sizeof (float));
	float *x_ref_in;
	x_ref_in = (float *)malloc(X_REF_IN_LENGTH*sizeof (float));
	float *u_out;
	u_out = (float *)malloc(U_OUT_LENGTH*sizeof (float));


	////////////////////////////////////////
	//read x0_in vector

	// Open stimulus x0_in.dat file for reading
	sprintf(filename,"x0_in.dat");
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
		if  (i < X0_IN_LENGTH) {
			x0_in[i]=(float)myValues1[i];

			#if FLOAT_FIX_X0_IN == 1
				tmp_value=(int32_t)(x0_in[i]*(float)pow(2,(X0_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_x0_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_X0_IN == 0
				memory_inout[i+byte_x0_in_offset/4] = (float)x0_in[i];
			#endif
		}

	}


	////////////////////////////////////////
	//read x_ref_in vector

	// Open stimulus x_ref_in.dat file for reading
	sprintf(filename,"x_ref_in.dat");
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
		if  (i < X_REF_IN_LENGTH) {
			x_ref_in[i]=(float)myValues2[i];

			#if FLOAT_FIX_X_REF_IN == 1
				tmp_value=(int32_t)(x_ref_in[i]*(float)pow(2,(X_REF_IN_FRACTIONLENGTH)));
				memory_inout[i+byte_x_ref_in_offset/4] = *(uint32_t*)&tmp_value;
			#elif FLOAT_FIX_X_REF_IN == 0
				memory_inout[i+byte_x_ref_in_offset/4] = (float)x_ref_in[i];
			#endif
		}

	}


	/////////////////////////////////////
	// foo c-simulation
	
	foo(	
				byte_x0_in_offset,
				byte_x_ref_in_offset,
				byte_u_out_offset,
				memory_inout);
	
	
	/////////////////////////////////////
	// read computed u_out and store it as u_out.dat
	pFile = fopen ("u_out.dat","w+");

	for (int i = 0; i < U_OUT_LENGTH; i++)
	{

		#if FLOAT_FIX_U_OUT == 1
			tmp_value=*(int32_t*)&memory_inout[i+byte_u_out_offset/4];
			u_out[i]=((float)tmp_value)/(float)pow(2,(U_OUT_FRACTIONLENGTH));
		#elif FLOAT_FIX_U_OUT == 0
			u_out[i]=(float)memory_inout[i+byte_u_out_offset/4];
		#endif
		
		fprintf(pFile,"%f \n ",u_out[i]);

	}
	fprintf(pFile,"\n");
	fclose (pFile);
		

	return 0;
}
