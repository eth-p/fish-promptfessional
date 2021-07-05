# Prompt Component: Status
# Displays the $status of the previously executed command.
#
# Options:
#   --always     :: Always show the component, even if the last command was successful.
#   --with-code  :: Show the exit code instead of just "!" or " ".
#
# Colors:
#   component.status.ok     :: Used when the last command was successful.
#   component.status.error  :: Used when the last command was unsuccessful.
function promptfessional_component_status --description "Promptfessional Component: Status"
    argparse -i 'always' 'with-code' 'symbol=' -- $argv
    [ -n "$_flag_symbol" ] || set _flag_symbol '!'
    
    # Ensure that __promptfessional_last_interactive_status is defined.
    [ -n "$__promptfessional_last_interactive_status" ] || set -g __promptfessional_last_interactive_status 0

	# Return early if it's zero.
    if [ "$__promptfessional_last_interactive_status" = 0 ] && not [ -n "$_flag_always" ]
        return 0
    end

    # Set the color.
    if [ "$__promptfessional_last_interactive_status" -eq 0 ]
        promptfessional color component.status.ok
    else
        promptfessional color component.status.error
    end

    # Print the code or symbol.
    if [ -n "$_flag_with_code" ]
        printf "%s" "$__promptfessional_last_interactive_status"
    else if [ "$__promptfessional_last_interactive_status" -eq 0 ]
        printf " "
    else
        printf "%s" "$_flag_symbol"
    end
end

function __capture_status --on-event fish_postexec
    set -g __promptfessional_last_interactive_status $status
end
