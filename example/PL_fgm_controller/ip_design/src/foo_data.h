/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include <vector>
#include <iostream>
#include <stdio.h>
#include "math.h"
#include "ap_fixed.h"
#include <stdint.h>
#include <cstdlib>
#include <cstring>
#include <stdio.h>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <hls_math.h>


// Define FLOAT_FIX_VECTOR_NAME=1 to enable  fixed-point (up to 32 bits word length) arithmetic precision or 
// FLOAT_FIX_VECTOR_NAME=0 to enable floating-point single arithmetic precision.
#define FLOAT_FIX_X_IN 1
#define FLOAT_FIX_NUM_ITER_IN 1
#define FLOAT_FIX_X_OUT 1

//Input vectors INTEGERLENGTH:
#define X_IN_INTEGERLENGTH 8
#define NUM_ITER_IN_INTEGERLENGTH 16
//Output vectors INTEGERLENGTH:
#define X_OUT_INTEGERLENGTH 8


//Input vectors FRACTIONLENGTH:
#define X_IN_FRACTIONLENGTH 16
#define NUM_ITER_IN_FRACTIONLENGTH 0
//Output vectors FRACTIONLENGTH:
#define X_OUT_FRACTIONLENGTH 16


//Input vectors size:
#define X_IN_LENGTH 40
#define NUM_ITER_IN_LENGTH 1
//Output vectors size:
#define X_OUT_LENGTH 40




typedef uint32_t data_t_memory;


#if FLOAT_FIX_X_IN == 1
	typedef ap_fixed<X_IN_INTEGERLENGTH+X_IN_FRACTIONLENGTH,X_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_x_in;
	typedef ap_fixed<32,32-X_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_x_in;
#endif
#if FLOAT_FIX_NUM_ITER_IN == 1
	typedef ap_fixed<NUM_ITER_IN_INTEGERLENGTH+NUM_ITER_IN_FRACTIONLENGTH,NUM_ITER_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_num_iter_in;
	typedef ap_fixed<32,32-NUM_ITER_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_num_iter_in;
#endif
#if FLOAT_FIX_X_IN == 0
	typedef float data_t_x_in;
	typedef float data_t_interface_x_in;
#endif
#if FLOAT_FIX_NUM_ITER_IN == 0
	typedef float data_t_num_iter_in;
	typedef float data_t_interface_num_iter_in;
#endif
#if FLOAT_FIX_X_OUT == 1 
	typedef ap_fixed<X_OUT_INTEGERLENGTH+X_OUT_FRACTIONLENGTH,X_OUT_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_x_out;
	typedef ap_fixed<32,32-X_OUT_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_x_out;
#endif
#if FLOAT_FIX_X_OUT == 0 
	typedef float data_t_x_out;
	typedef float data_t_interface_x_out;
#endif
