# Prompt Component: Sudo
# Displays a "$" if the user is root (uid 0).
#
# Options:
#   --uid     :: The uid of the root user. (default: 0)
#   --symbol  :: The symbol to display.    (default: $)
#
# Colors:
#   component.sudo  :: Used when the user is root.
function promptfessional_component_sudo
    argparse 'uid' 'symbol=' -- $argv

    [ -n "$_flag_uid" ]    || set _flag_uid '0'
    [ -n "$_flag_symbol" ] || set _flag_symbol '$'
    if [ "$__promptfessional_uid" -eq "$_flag_uid" ]
        promptfessional color component.sudo
        printf "%s" "$_flag_symbol"
    end
end

set -g __promptfessional_uid (id -u)
