/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/



#include "mex.h"
#include "matrix.h"

#include"FPGAclientAPI.h"




    


    
    
   




void mexFunction( int nlhs, mxArray *plhs[] , int nrhs, const mxArray *prhs[] )
{
	double * time_matlab;
	double * time_fpga;
	double * data;
	double * M_values;
	mwSize row_size,col_size;
	mwSize  *dims;
	double * results;
	double output_data_eth[ETH_PACKET_LENGTH_RECV];
	int i,j;
	double time_fpga_int;
    int flag;
	
	double flag_IP_running;
   
    double port;
    double link;
    double ptype;
    double pID;
    double poutsize;
	char *FPGA_ip_address;
    int buflen;
    int status;
    unsigned FPGA_port_number;
    unsigned FPGA_link;
    unsigned Packet_type;
    unsigned packet_input_size;
    unsigned packet_internal_ID;
    unsigned packet_output_size;
    double *input_data;
    double *output_data;
    double input_data_eth[ETH_PACKET_LENGTH];
    double packet_internal_ID_offset;
    

    
	if(nrhs > 4 || nlhs > 3)
	{
	    
	    plhs[0]    = mxCreateDoubleMatrix(0 , 0 ,  mxREAL);
        plhs[1]    = mxCreateDoubleMatrix(0 , 0 ,  mxREAL);
        plhs[2]    = mxCreateDoubleMatrix(0 , 0 ,  mxREAL);
	    return;
	}
	
   
    

            
     //input array
    data = mxGetPr(prhs[0]);
    dims = mxGetDimensions(prhs[0]);
    if (dims[1]==1)
        packet_input_size = dims[0]; //vector length
    else if (dims[0]==1)
        packet_input_size = dims[1]; //vector length

    input_data = (double*)mxMalloc(packet_input_size*sizeof(double));

 
    //Packet_type
    ptype = mxGetScalar(prhs[1]);
    Packet_type=(unsigned)(ptype);
    
     //packet_internal_ID
    pID = mxGetScalar(prhs[2]);
    packet_internal_ID=(unsigned)(pID);
    
    //packet_output_size
    poutsize = mxGetScalar(prhs[3]);
    packet_output_size=(unsigned)(poutsize);
    
   
    for (i=0; i<packet_input_size; i++) {
		input_data[i]=*(data+i);
		//printf ("input_data[%d]=%f \n",i,input_data[i]);
	}
    
	
    //malloc output vector
    output_data = (double*)mxMalloc(packet_output_size*sizeof(double));
	
	time_fpga_int=0;
    
	
   
	FPGAclient( input_data, packet_input_size, Packet_type, packet_internal_ID, packet_output_size, output_data,&time_fpga_int);

    
   	// ----- output ----- 
    
    
    // Create a 0-by-0 mxArray: allocate the memory dynamically
    plhs[0] = mxCreateNumericMatrix(0, 0, mxDOUBLE_CLASS, mxREAL);

    // Put the output_data array into the mxArray and define its dimensions 
    mxSetPr(plhs[0], output_data);
    mxSetM(plhs[0], packet_output_size);
    mxSetN(plhs[0], 1);

	plhs[1]    = mxCreateDoubleScalar  (mxREAL );
	time_fpga = (double *) mxGetPr(plhs[1]);
    
  *time_fpga=time_fpga_int;
  
  mxFree(input_data);

	  
}





