

# ####################################################################################################################
# #################################################################################################################### 
#  PROCEDURES
# #################################################################################################################### 
# #################################################################################################################### 


# ############################# 
# procedure used to pass arguments to a tcl script (source: http://wiki.tcl.tk/10025)
proc src {file args} {
  set argv $::argv
  set argc $::argc
  set ::argv $args
  set ::argc [llength $args]
  set code [catch {uplevel [list source $file]} return]
  set ::argv $argv
  set ::argc $argc
  return -code $code $return
}


# ####################################################################################################################
# #################################################################################################################### 
#  BUILD
# #################################################################################################################### 
# #################################################################################################################### 

# Project name
set project_name "eMPC_controller"
# ############################# 
# #############################   
# Load configuration parameters


#load configuration parameters
set  file_name ""
append file_name "../../.metadata/" $project_name "_configuration_parameters.dat"
set fp [open $file_name r]
set file_data [read $fp]
close $fp
set data [split $file_data "\n"]

set num_input_vectors [lindex $data 3]
set num_output_vectors [lindex $data [expr ($num_input_vectors * 5) + 4 + 1]]
set fclk [lindex $data [expr ($num_input_vectors * 5) + ($num_output_vectors * 5) + 5 + 2]]
set FPGA_name [lindex $data [expr ($num_input_vectors * 5) + ($num_output_vectors * 5) + 5 + 4]]
set type_test [lindex $data [expr ($num_input_vectors * 5) + ($num_output_vectors * 5) + 5 + 14]]
set input_vectors {}
for {set i 0} {$i < $num_input_vectors} {incr i} {
    lappend input_vectors [lindex $data [expr 4 + ($i * 5)]]
} 
set output_vectors {}
for {set i 0} {$i < $num_output_vectors} {incr i} {
    lappend output_vectors [lindex $data [expr ($num_input_vectors * 5) + 4 + 2 + ($i * 5)]]
}

cd ../..

# ############################# 
# ############################# 
# Run Vivado HLS

# Create a new project named "project_name"
cd ip_design/test/prj
open_project -reset $project_name
set_top foo


#added by Bulat
#Copy project settings files from src if they exist
if { [file exists ../../src/.cproject] } {
	file copy -force ../../src/.cproject $project_name
}

if { [file exists ../../src/.project] } {
	file copy -force ../../src/.project $project_name
}

if { [file exists ../../src/vivado_hls.app] } {
	file copy -force ../../src/vivado_hls.app $project_name
}
#end added by Bulat



# Add here below other files made by the user:
set filename [format "../../src/foo_data.h"] 
add_files $filename
set filename [format "../../src/foo_user.cpp"] 
add_files $filename
set filename [format "../../src/foo.cpp"] 
add_files $filename

# Add testbench files
set filename [format "../../src/foo_test.cpp"]
add_files -tb $filename
unset filename
foreach i $input_vectors {
	append tmp_name "../stimuli/" $project_name "/" $i "_in.dat" 
	set filename [format $tmp_name] 
	add_files -tb $filename
	unset filename
	unset tmp_name
}

# compute circuit clock period in ns
set time [ expr 1000/$fclk]

# Configure the design
open_solution -reset "solution1"
set FPGA_name_full ""
append FPGA_name_full "{" $FPGA_name "}"
set_part $FPGA_name_full
create_clock -period $time -name default
# Configure implementation directives to build an optimized FPGA circuit
set directives_destination_name ""
append directives_destination_name "../../src/" $project_name "_directives.tcl"
source $directives_destination_name

# Build and run design simulation
if {$type_test==1} {
	csim_design -clean
} elseif {$type_test==2} {
	csynth_design
	cosim_design -trace_level all -rtl verilog -tool xsim
} elseif {$type_test==3} {
	csynth_design
	cosim_design -trace_level all -rtl verilog -tool modelsim
}

# close Vivado HLS project
close_solution
close_project


foreach i $output_vectors {
	set source_file ""
	set target_file ""
	append source_file $project_name "/solution1/"
	if {$type_test==1} {
		append source_file "csim/build/" $i "_out.dat"
	} elseif {$type_test==2} {
		append source_file "sim/wrapc/" $i "_out.dat" 
	} elseif {$type_test==3} {
		append source_file "sim/wrapc/" $i "_out.dat" 
	}
	append target_file "../results/" $project_name "/" $i "_out.dat" 
	file copy -force $source_file $target_file

}


cd ..
cd ..
cd ..

exit
