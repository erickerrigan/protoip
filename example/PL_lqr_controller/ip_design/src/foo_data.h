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
#include <math.h>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>


// Define FLOAT_FIX_VECTOR_NAME=1 to enable  fixed-point (up to 32 bits word length) arithmetic precision or 
// FLOAT_FIX_VECTOR_NAME=0 to enable floating-point single arithmetic precision.
#define FLOAT_FIX_X0_IN 1
#define FLOAT_FIX_X_REF_IN 1
#define FLOAT_FIX_U_OUT 1

//Input vectors INTEGERLENGTH:
#define X0_IN_INTEGERLENGTH 8
#define X_REF_IN_INTEGERLENGTH 8
//Output vectors INTEGERLENGTH:
#define U_OUT_INTEGERLENGTH 8


//Input vectors FRACTIONLENGTH:
#define X0_IN_FRACTIONLENGTH 16
#define X_REF_IN_FRACTIONLENGTH 16
//Output vectors FRACTIONLENGTH:
#define U_OUT_FRACTIONLENGTH 16


//Input vectors size:
#define X0_IN_LENGTH 6
#define X_REF_IN_LENGTH 6
//Output vectors size:
#define U_OUT_LENGTH 3




typedef uint32_t data_t_memory;


#if FLOAT_FIX_X0_IN == 1
	typedef ap_fixed<X0_IN_INTEGERLENGTH+X0_IN_FRACTIONLENGTH,X0_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_x0_in;
	typedef ap_fixed<32,32-X0_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_x0_in;
#endif
#if FLOAT_FIX_X_REF_IN == 1
	typedef ap_fixed<X_REF_IN_INTEGERLENGTH+X_REF_IN_FRACTIONLENGTH,X_REF_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_x_ref_in;
	typedef ap_fixed<32,32-X_REF_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_x_ref_in;
#endif
#if FLOAT_FIX_X0_IN == 0
	typedef float data_t_x0_in;
	typedef float data_t_interface_x0_in;
#endif
#if FLOAT_FIX_X_REF_IN == 0
	typedef float data_t_x_ref_in;
	typedef float data_t_interface_x_ref_in;
#endif
#if FLOAT_FIX_U_OUT == 1 
	typedef ap_fixed<U_OUT_INTEGERLENGTH+U_OUT_FRACTIONLENGTH,U_OUT_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_u_out;
	typedef ap_fixed<32,32-U_OUT_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_u_out;
#endif
#if FLOAT_FIX_U_OUT == 0 
	typedef float data_t_u_out;
	typedef float data_t_interface_u_out;
#endif
