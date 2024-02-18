# Prompt Component: VENV
# Displays "venv" if using a Python virtual environment.
#
# Options:
#   --symbol  :: The symbol to display.    (default: venv)
#
# Colors:
#   component.venv  :: The color of the virtual environment prompt.
function promptfessional_component_venv
	argparse symbol='' -- $argv

	set -g VIRTUAL_ENV_DISABLE_PROMPT true

	# Don't display the component if not inside a virtual environment.
	if [ -z "$VIRTUAL_ENV" ]
		return 1
	end

	# Render the component.
	[ -n "$_flag_symbol" ] || set _flag_symbol 'venv'
	promptfessional color component.venv
	printf "%s" "$_flag_symbol"
end

