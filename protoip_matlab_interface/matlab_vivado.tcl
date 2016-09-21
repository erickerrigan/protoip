# extract command name
set command_name [lindex $argv 0]
set tmp_str "tclapp::icl::protoip::"
set tmp_str $tmp_str$command_name
set command_name $tmp_str


# extract arguments
set arguments ""
for {set i 1} {$i < [llength $argv]} {incr i 2} {
	set dash "-"
	set arg_type [lindex $argv $i]
	set arg_type $dash$arg_type
	set arg_value [lindex $argv [expr $i + 1]]

	set arguments [concat $arguments $arg_type $arg_value]

}

# call command from XilinxTclStore
eval $command_name $arguments

exit