

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
set new_input_vectors {}
set new_input_vectors_length {}
set new_input_vectors_type {}
set new_input_vectors_integer_length {}
set new_input_vectors_fraction_length {}
set new_output_vectors {}
set new_output_vectors_length {}
set new_output_vectors_type {}
set new_output_vectors_integer_length {}
set new_output_vectors_fraction_length {}

for {set i 0} {$i < $new_num_input_vectors} {incr i} {
	lappend new_input_vectors [lindex $data [expr 4 + ($i * 5)]]
	lappend new_input_vectors_length [lindex $data [expr 5 + ($i * 5)]]
	lappend new_input_vectors_type [lindex $data [expr 6 + ($i * 5)]]
	lappend new_input_vectors_integer_length [lindex $data [expr 7 + ($i * 5)]]
	lappend new_input_vectors_fraction_length [lindex $data [expr 8 + ($i * 5)]]
}
for {set i 0} {$i < $new_num_output_vectors} {incr i} {
	lappend new_output_vectors [lindex $data [expr ($new_num_input_vectors * 5) + 4 + 2 + ($i * 5)]]
	lappend new_output_vectors_length [lindex $data [expr ($new_num_input_vectors * 5) + 4 + 3 + ($i * 5)]]
	lappend new_output_vectors_type [lindex $data [expr ($new_num_input_vectors * 5) + 4 + 4 + ($i * 5)]]
	lappend new_output_vectors_integer_length [lindex $data [expr ($new_num_input_vectors * 5) + 4 + 5 + ($i * 5)]]
	lappend new_output_vectors_fraction_length [lindex $data [expr ($new_num_input_vectors * 5) + 4 + 6 + ($i * 5)]]
}

set new_fclk [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 2]] 
set new_FPGA_name [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 4]] 
set new_board_name [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 6]] 
set new_type_eth [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 8]] 
set new_mem_base_address [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 10]] 
set new_num_test [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 12]] 
set new_type_test [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 14]] 
set new_type_template [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 16]]
set new_type_design_flow [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 18]] 


# update configuration parameters
set m 0
foreach i $new_input_vectors_type {
	if {$i==1} {
		set new_input_vectors_type [lreplace $new_input_vectors_type $m $m "fix"]
	} else {
		set new_input_vectors_type [lreplace $new_input_vectors_type $m $m "float"]
	}
	incr m
}
set m 0
foreach i $new_output_vectors_type {
	if {$i==1} {
		set new_output_vectors_type [lreplace $new_output_vectors_type $m $m "fix"]
	} else {
		set new_output_vectors_type [lreplace $new_output_vectors_type $m $m "float"]
	}
	incr m
}



	if {$r_project_name == {}} {
	
			error " -E- NO project name specified. Use the -usage option for more details."
			
		} else {
	
		

		
			set num_input_vectors $new_num_input_vectors
			set num_output_vectors $new_num_output_vectors
			set input_vectors $new_input_vectors 
			set input_vectors_length $new_input_vectors_length 
			set input_vectors_type $new_input_vectors_type 
			set input_vectors_integer_length $new_input_vectors_integer_length 
			set input_vectors_fraction_length $new_input_vectors_fraction_length 
			set output_vectors $new_output_vectors
			set output_vectors_length $new_output_vectors_length 
			set output_vectors_type $new_output_vectors_type 
			set output_vectors_integer_length $new_output_vectors_integer_length 
			set output_vectors_fraction_length $new_output_vectors_fraction_length 
			set type_template $new_type_template
			set type_design_flow $new_type_design_flow


			set str_fix "fix"
			set str_float "float"
			
			set count_is_float 0
			set count_is_fix 0
			foreach i $input_vectors_type {
				if {$i==$str_fix} {
					incr count_is_fix
				} else {
					incr count_is_float
				}
			}
			foreach i $output_vectors_type {
				if {$i==$str_fix} {
					incr count_is_fix
				} else {
					incr count_is_float
				}
			}
			
			if {$type_template == "PL"} {
		
			if {$count_is_fix==[expr $num_input_vectors+$num_output_vectors] || $count_is_float==[expr $num_input_vectors+$num_output_vectors]} {

				tclapp::icl::protoip::make_template -project_name $r_project_name
				
			} else {
			
				puts " -E- Inputs and Outputs must be either fixed-point or floating-point. Use the -usage option for more details."
				
			}
			
			} else {			
		
				set tmp_str ""
				append tmp_str " -E- Template project type " $type_template "is not supported. Please type 'icl::protoip::make_template -usage' for usage info"
				puts $tmp_str

			}
		}

exit