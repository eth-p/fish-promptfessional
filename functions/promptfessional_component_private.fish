# Prompt Component: Private
# Displays a "⦸" if the shell is not recording history.
#
# Options:
#   --symbol  :: The symbol to display.    (default: ⦸)
#
# Colors:
#   component.sudo  :: Used when the user is root.
function promptfessional_component_private
	argparse 'symbol=' -- $argv

	[ -n "$_flag_symbol" ] || set _flag_symbol '⦸'
	if [ "$fish_private_mode" = "1" ]
		promptfessional color component.private
		printf "%s" "$_flag_symbol"
	end
end

