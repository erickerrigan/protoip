


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

set new_num_test [lindex $data [expr ($new_num_input_vectors * 5) + ($new_num_output_vectors * 5) + 5 + 12]] 

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

if {$old_type_eth==0} {
	set type_eth "udp"
} elseif {$old_type_eth==1} {
	set type_eth "tcp"
}		

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
set FPGA_name $old_FPGA_name
set fclk $old_fclk

set mem_base_address $old_mem_base_address 
set num_test $new_num_test 
set type_test "none"
set type_design_flow "matlab"
set type_template $old_type_template

set tmp_dir "ip_prototype/test/results/"
append tmp_dir $r_project_name
file mkdir $tmp_dir


[tclapp::icl::protoip::make_template::make_project_configuration_parameters_dat $r_project_name $input_vectors $input_vectors_length $input_vectors_type $input_vectors_integer_length $input_vectors_fraction_length $output_vectors $output_vectors_length $output_vectors_type $output_vectors_integer_length $output_vectors_fraction_length $fclk $FPGA_name $board_name $type_eth $mem_base_address $num_test $type_test $type_template $type_design_flow]
[::tclapp::icl::protoip::make_template::make_ip_configuration_parameters_readme_txt $r_project_name]
# update ip_design/src/FPGAclientAPI.h file
[::tclapp::icl::protoip::make_template::make_FPGAclientAPI_h  $r_project_name]

set tmp_dir "ip_prototype/test/results/"
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
	


exit