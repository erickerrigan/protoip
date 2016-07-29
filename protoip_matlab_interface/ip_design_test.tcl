
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


#added by Bulat
set new_num_soc_input_vectors [lindex $data [expr [lsearch $data "#soc_Input"] + 1 ]]
set new_soc_input_vectors {}
set new_soc_input_vectors_length {}
			
for {set i 0} {$i < $new_num_soc_input_vectors} {incr i} {
	lappend new_soc_input_vectors [lindex $data [expr [lsearch $data "#soc_Input"] + 2 + ($i * 5) ]]
	lappend new_soc_input_vectors_length [lindex $data [expr [lsearch $data "#soc_Input"] + 3 + ($i * 5) ]]
}		
			
			
set new_num_soc_output_vectors [lindex $data [expr [lsearch $data "#soc_Output"] + 1 ]]
set new_soc_output_vectors {}
set new_soc_output_vectors_length {}
			
for {set i 0} {$i < $new_num_soc_output_vectors} {incr i} {
	lappend new_soc_output_vectors [lindex $data [expr [lsearch $data "#soc_Output"] + 2 + ($i * 5) ]]
	lappend new_soc_output_vectors_length [lindex $data [expr [lsearch $data "#soc_Output"] + 3 + ($i * 5) ]]
}
#end added by Bulat

	set  file_name ""
	append file_name ".metadata/" $r_project_name "_configuration_parameters.dat"
	
	if {$r_project_name == {}} {
	
			error " -E- NO project name specified. Use the -usage option for more details."
			
		} else {
	
		if {[file exists $file_name] == 0} { 

			set tmp_error ""
			append tmp_error "-E- " $r_project_name " does NOT exist. Use the -usage option for more details."
			error $tmp_error
			
		} else {
		
		if {$new_type_test == {}} { 

			error "-E- NO test(s) type specified. Use the -usage option for more details."
			
		} else {

		if {$new_num_test == {}} { 

			error "-E- NO number of test(s) type specified. Use the -usage option for more details."
			
		} else {


		set  file_name ""
		append file_name ".metadata/" $r_project_name "_configuration_parameters.dat"
		set fp [open $file_name r]
		set file_data [read $fp]
		close $fp
		set data [split $file_data "\n"]


		set old_num_input_vectors [lindex $data 3]
		set old_num_output_vectors [lindex $data [expr ($old_num_input_vectors * 5) + 4 + 1]]
		set old_input_vectors {}
		set old_input_vectors_length {}
		set old_input_vectors_type {}
		set old_input_vectors_integer_length {}
		set old_input_vectors_fraction_length {}
		set old_output_vectors {}
		set old_output_vectors_length {}
		set old_output_vectors_type {}
		set old_output_vectors_integer_length {}
		set old_output_vectors_fraction_length {}

		for {set i 0} {$i < $old_num_input_vectors} {incr i} {
			lappend old_input_vectors [lindex $data [expr 4 + ($i * 5)]]
			lappend old_input_vectors_length [lindex $data [expr 5 + ($i * 5)]]
			lappend old_input_vectors_type [lindex $data [expr 6 + ($i * 5)]]
			lappend old_input_vectors_integer_length [lindex $data [expr 7 + ($i * 5)]]
			lappend old_input_vectors_fraction_length [lindex $data [expr 8 + ($i * 5)]]
		}
		for {set i 0} {$i < $old_num_output_vectors} {incr i} {
			lappend old_output_vectors [lindex $data [expr ($old_num_input_vectors * 5) + 4 + 2 + ($i * 5)]]
			lappend old_output_vectors_length [lindex $data [expr ($old_num_input_vectors * 5) + 4 + 3 + ($i * 5)]]
			lappend old_output_vectors_type [lindex $data [expr ($old_num_input_vectors * 5) + 4 + 4 + ($i * 5)]]
			lappend old_output_vectors_integer_length [lindex $data [expr ($old_num_input_vectors * 5) + 4 + 5 + ($i * 5)]]
			lappend old_output_vectors_fraction_length [lindex $data [expr ($old_num_input_vectors * 5) + 4 + 6 + ($i * 5)]]
		}

		set old_fclk [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 2]] 
		set old_FPGA_name [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 4]] 
		set old_board_name [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 6]] 
		set old_type_eth [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 8]] 
		set old_mem_base_address [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 10]] 
		set old_num_test [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 12]] 
		set old_type_test [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 14]] 
		set old_type_template [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 16]]
		set old_type_design_flow [lindex $data [expr ($old_num_input_vectors * 5) + ($old_num_output_vectors * 5) + 5 + 18]]


		#added by Bulat
		set old_num_soc_input_vectors [lindex $data [expr [lsearch $data "#soc_Input"] + 1 ]]
		set old_soc_input_vectors {}
		set old_soc_input_vectors_length {}
			
		for {set i 0} {$i < $old_num_soc_input_vectors} {incr i} {
			lappend old_soc_input_vectors [lindex $data [expr [lsearch $data "#soc_Input"] + 2 + ($i * 5) ]]
			lappend old_soc_input_vectors_length [lindex $data [expr [lsearch $data "#soc_Input"] + 3 + ($i * 5) ]]
		}		
			
			
		set old_num_soc_output_vectors [lindex $data [expr [lsearch $data "#soc_Output"] + 1 ]]
		set old_soc_output_vectors {}
		set old_soc_output_vectors_length {}
			
		for {set i 0} {$i < $old_num_soc_output_vectors} {incr i} {
			lappend old_soc_output_vectors [lindex $data [expr [lsearch $data "#soc_Output"] + 2 + ($i * 5) ]]
			lappend old_soc_output_vectors_length [lindex $data [expr [lsearch $data "#soc_Output"] + 3 + ($i * 5) ]]
		}
		#end added by Bulat


			# update configuration parameters
			set m 0
			foreach i $old_input_vectors_type {
				if {$i==1} {
					set old_input_vectors_type [lreplace $old_input_vectors_type $m $m "fix"]
				} else {
					set old_input_vectors_type [lreplace $old_input_vectors_type $m $m "float"]
				}
				incr m
			}
			set m 0
			foreach i $old_output_vectors_type {
				if {$i==1} {
					set old_output_vectors_type [lreplace $old_output_vectors_type $m $m "fix"]
				} else {
					set old_output_vectors_type [lreplace $old_output_vectors_type $m $m "float"]
				}
				incr m
			}
					
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

		 
			
		
			if {$old_type_eth==0} {
				set type_eth "udp"
			} elseif {$old_type_eth==1} {
				set type_eth "tcp"
			}
			
			
			
			
			if {$new_FPGA_name == {}} {
				set FPGA_name $old_FPGA_name
			} else {
				set FPGA_name $new_FPGA_name
			}
			if {$new_fclk == {}} {
				set fclk $old_fclk
			} else {
				set fclk $new_fclk
			}
			
			set m 0
			foreach i $new_input_vectors {
				set position [lsearch -exact $old_input_vectors $i]
				puts $position
				if {$position !=-1} {
					set old_input_vectors [lreplace $old_input_vectors $position $position $i]
					set old_input_vectors_length [lreplace $old_input_vectors_length $position $position [lindex $new_input_vectors_length $m]]
					set old_input_vectors_type [lreplace $old_input_vectors_type $position $position [lindex $new_input_vectors_type $m]]
					set old_input_vectors_integer_length [lreplace $old_input_vectors_integer_length $position $position [lindex $new_input_vectors_integer_length $m]]
					set old_input_vectors_fraction_length [lreplace $old_input_vectors_fraction_length $position $position [lindex $new_input_vectors_fraction_length $m]]	
				} else {
				
					set tmp_error ""
					append tmp_error " -E- NO input vector " $i " found. Use the -usage option for more details."
					error $tmp_error

				}
				
				incr m
			}
			set m 0
			foreach i $new_output_vectors {
				set position [lsearch -exact $old_output_vectors $i]
				if {$position !=-1} {
					set old_output_vectors [lreplace $old_output_vectors $position $position $i]
					set old_output_vectors_length [lreplace $old_output_vectors_length $position $position [lindex $new_output_vectors_length $m]]
					set old_output_vectors_type [lreplace $old_output_vectors_type $position $position [lindex $new_output_vectors_type $m]]
					set old_output_vectors_integer_length [lreplace $old_output_vectors_integer_length $position $position [lindex $new_output_vectors_integer_length $m]]
					set old_output_vectors_fraction_length [lreplace $old_output_vectors_fraction_length $position $position [lindex $new_output_vectors_fraction_length $m]]	
				} else {
				
					set tmp_error ""
					append tmp_error " -E- NO output vector " $i " found. Use the -usage option for more details."
					error $tmp_error
				}
				incr m
			}


			#added by Bulat
			set m 0
			foreach i $new_soc_input_vectors {
				set position [lsearch -exact $old_soc_input_vectors $i]
				puts $position
				if {$position !=-1} {
					set old_soc_input_vectors [lreplace $old_soc_input_vectors $position $position $i]
					set old_soc_input_vectors_length [lreplace $old_soc_input_vectors_length $position $position [lindex $new_soc_input_vectors_length $m]]
				} else {
				
					set tmp_error ""
					append tmp_error " -E- NO input vector " $i " found. Use the -usage option for more details."
					error $tmp_error
				}
				incr m
			}
			
			set m 0
			foreach i $new_soc_output_vectors {
				set position [lsearch -exact $old_soc_output_vectors $i]
				if {$position !=-1} {
					set old_soc_output_vectors [lreplace $old_soc_output_vectors $position $position $i]
					set old_soc_output_vectors_length [lreplace $old_soc_output_vectors_length $position $position [lindex $new_soc_output_vectors_length $m]]
				} else {
					set tmp_error ""
					append tmp_error " -E- NO output vector " $i " found. Use the -usage option for more details."
					error $tmp_error
				}
				incr m
			}
			
			
			#end added by Bulat
			
			set input_vectors $old_input_vectors 
			set input_vectors_length $old_input_vectors_length 
			set input_vectors_type $old_input_vectors_type 
			set input_vectors_integer_length $old_input_vectors_integer_length 
			set input_vectors_fraction_length $old_input_vectors_fraction_length 
			set output_vectors $old_output_vectors
			set output_vectors_length $old_output_vectors_length 
			set output_vectors_type $old_output_vectors_type 
			set output_vectors_integer_length $old_output_vectors_integer_length 
			set output_vectors_fraction_length $old_output_vectors_fraction_length 
			
			set board_name $old_board_name 
			
			set mem_base_address $old_mem_base_address 
			set num_test $new_num_test 
			set type_test $new_type_test
			set type_design_flow $old_type_design_flow
			set type_template $old_type_template


			#added by Bulat
			set soc_input_vectors $old_soc_input_vectors
			set soc_input_vectors_length $old_soc_input_vectors_length
			set soc_output_vectors $old_soc_output_vectors
			set soc_output_vectors_length $old_soc_output_vectors_length
			#end added by Bulat



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
		
			if {$count_is_fix==[expr $old_num_input_vectors+$old_num_output_vectors] || $count_is_float==[expr $old_num_input_vectors+$old_num_output_vectors]} {

				set type_design_flow "matlab"
				#[tclapp::icl::protoip::make_template::make_project_configuration_parameters_dat $r_project_name $input_vectors $input_vectors_length $input_vectors_type $input_vectors_integer_length $input_vectors_fraction_length $output_vectors $output_vectors_length $output_vectors_type $output_vectors_integer_length $output_vectors_fraction_length $fclk $FPGA_name $board_name $type_eth $mem_base_address $num_test $type_test $type_template $type_design_flow]
				[tclapp::icl::protoip::make_template::make_project_configuration_parameters_dat $r_project_name $input_vectors $input_vectors_length $input_vectors_type $input_vectors_integer_length $input_vectors_fraction_length $output_vectors $output_vectors_length $output_vectors_type $output_vectors_integer_length $output_vectors_fraction_length $fclk $FPGA_name $board_name $type_eth $mem_base_address $num_test $type_test $type_template $type_design_flow $soc_input_vectors $soc_input_vectors_length $soc_output_vectors $soc_output_vectors_length]
				
				[::tclapp::icl::protoip::make_template::make_ip_configuration_parameters_readme_txt $r_project_name]
				# update ip_design/src/foo_data.h file
				[::tclapp::icl::protoip::make_template::make_foo_data_h $r_project_name]
				# update ip_design/src/FPGAclientAPI.h file
				[::tclapp::icl::protoip::make_template::make_FPGAclientAPI_h  $r_project_name]
				# update directives
				[::tclapp::icl::protoip::make_template::update_directives  $r_project_name] 
				
				
				set tmp_dir "ip_design/test/results/"
				append tmp_dir $r_project_name
				cd $tmp_dir
				
				set time_stamp [clock format [clock seconds] -format "%Y-%m-%d_T%H-%M"]
				
				foreach i $input_vectors {
					set file_name ""
					append file_name $i "_in_log.dat"
					if {[file exists $file_name] == 1} { 
						set file_name_new ""
						append file_name_new $time_stamp "_backup_" $i "_in_log.dat"
						file copy -force $file_name $file_name_new
						file delete -force $file_name
					}
				}
				
				foreach i $output_vectors {
					set file_name ""
					append file_name "fpga_" $i "_out_log.dat"
					if {[file exists $file_name] == 1} { 
						set file_name_new ""
						append file_name_new $time_stamp "_backup_fpga_" $i "_out_log.dat"
						file copy -force $file_name $file_name_new
						file delete -force $file_name
					}
					set file_name ""
					append file_name "matlab_" $i "_out_log.dat"
					if {[file exists $file_name] == 1} { 
						set file_name_new ""
						append file_name_new $time_stamp "_backup_matlab_" $i "_out_log.dat"
						file copy -force $file_name $file_name_new
						file delete -force $file_name
					}
				}
				
				set file_name ""
				append file_name "fpga_time_log.dat"
				if {[file exists $file_name] == 1} { 
					set file_name_new ""
					append file_name_new $time_stamp "_backup_fpga_time_log.dat"
					file copy -force $file_name $file_name_new
					file delete -force $file_name
				}
				
				cd ../../../../
				
				
			} else {
			
				puts " -E- Inputs and Outputs must be either fixed-point or floating-point. Use the -usage option for more details."
				
			}
		}
		}
		}
	}

exit