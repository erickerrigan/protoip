


#load function arguments passed from Matlab
set  file_name ""
append file_name ".metadata/configuration_parameters_matlab_interface.dat"
set fp [open $file_name r]
set file_data [read $fp]
close $fp
set data [split $file_data "\n"]

set r_project_name [lindex $data 1]
set new_num_input_vectors [lindex $data 3]
set new_num_output_vectors [lindex $data [expr ($new_num_input_vectors * 5) + 4 + 1]]

set new_from [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 20]]
set new_to [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 22]]



tclapp::install icl::protoip
tclapp::icl::protoip::ip_design_duplicate -from $new_from -to $new_to


	

exit