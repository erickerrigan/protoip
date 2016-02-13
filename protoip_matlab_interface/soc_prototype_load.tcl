


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


set new_board_name [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 6]] 
set new_type_eth [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 8]] 
set new_mem_base_address [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 10]] 

set  file_name ""
append file_name ".metadata/" $r_project_name "_configuration_parameters.dat"
set fp [open $file_name r]
set file_data [read $fp]
close $fp
set data [split $file_data "\n"]


set old_num_input_vectors [lindex $data 3]
set old_num_output_vectors [lindex $data [expr ($old_num_input_vectors * 5) + 4 + 1]]
set old_mem_base_address [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 10]] 

if {$new_mem_base_address=={}} {
	set mem_base_address $old_mem_base_address
} else {
	set mem_base_address $new_mem_base_address
}

tclapp::icl::protoip::soc_prototype_load -project_name $r_project_name -board_name $new_board_name -type_eth $new_type_eth -mem_base_address $mem_base_address


	

exit