# Prompt Component: Cmdtime
# Displays the execution time of the last command.
#
# Options:
#   --min-time  :: The number of milliseconds before showing up.
#   --min-slow  :: The number of milliseconds before the command is considered slow.  (default: 10000)
#   --precision :: The precision of floats. (default: 2)
#   --pattern   :: The pattern to use.      (default: "{color}{time}{unit_color}{unit}")
#
# Colors:
#   component.cmdtime       :: The color of the command time.
#   component.cmdtime.slow  :: The color of the command time if the command is slow.
#   component.cmdtime.unit  :: The color of the command time unit.
function promptfessional_component_cmdtime
	argparse 'min-time=' 'min-slow=' 'precision=' 'pattern=' -- $argv
	[ -n "$_flag_precision" ] || set _flag_precision 2
	[ -n "$_flag_min_time" ]  || set _flag_min_time 0
	[ -n "$_flag_min_slow" ]  || set _flag_min_slow 10000
	[ -n "$_flag_pattern" ]   || set _flag_pattern '{color}{time}{unit_color}{unit}'
	
	# If the command time doesn't meet the minimum, don't render.
	if [ -z "$CMD_DURATION" ] || [ "$CMD_DURATION" -lt "$_flag_min_time" ]
		return 1
	end
	
	# Abbreviate the command time.
	set -l duration_float "$CMD_DURATION"
	set -l duration_unit "ms"
	
	if [ "$duration_float" -gt 1000 ]
		set duration_float (math "$duration_float" / 1000)
		set duration_unit "s"
	end
	
	if [ "$duration_float" -gt 60 ]
		set duration_float (math "$duration_float" / 60)
		set duration_unit "m"
	end
	
	set duration_float (math --scale="$_flag_precision" "$duration_float")
	set -l duration_float_parts (string split "." "$duration_float")
	
	# Determine the color.
	set -l color_name 'component.cmdtime'
	if [ "$CMD_DURATION" -gt "$_flag_min_slow" ]
		set color_name 'component.cmdtime.slow'
	end
	
	# Render the command time.
	set -l color (promptfessional color "$color_name")
	set -l unit_color (promptfessional color component.cmdtime.unit)
	promptfessional util template "$_flag_pattern" \
		"color" "$color" \
		"unit_color" "$unit_color" \
		"time_ms" "$CMD_DURATION" \
		"time" "$duration_float" \
		"time_integer" "$duration_float_parts[1]" \
		"time_decimal" "$duration_float_parts[2]" \
		"unit" "$duration_unit"
end

