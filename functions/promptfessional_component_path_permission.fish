# Prompt Component: Path Permission
# Displays the permission of the current directory.
#
# Options:
#   --always          :: Always show the component, even if the user has full read-write.
#   --symbol-default  :: Text to show when the current directory is read-write.  (default: "[rw]")
#   --symbol-no-read  :: Text to show when the current directory is unreadable.  (default: "[na]")
#   --symbol-no-write :: Text to show when the current directory is unwritable.  (default: "[ro]")
#
# Colors:
#   component.path_permission           :: The default color.
#   component.path_permission.no_read   :: Used when the directory cannot be read.
#   component.path_permission.no_write  :: Used when the directory cannot be written to.
function promptfessional_component_path_permission --description "Promptfessional Component: Path Permission"
	argparse -i 'always' -- $argv
	[ -n "$_flag_symbol" ] || set _flag_symbol '[rw]'
	[ -n "$_flag_symbol_no_read" ] || set _flag_symbol_no_read '[na]'
	[ -n "$_flag_symbol_no_write" ] || set _flag_symbol_no_write '[ro]'

	set -l pwd (pwd)
	
	# Check unreadable.
	if ! [ -r "$pwd" ]
		promptfessional color component.path_permission.no_read --or component.path_permission
		printf "%s" "$_flag_symbol_no_read"
		return 0
	end
	
	# Check unwritable.
	if ! [ -w "$pwd" ]
		promptfessional color component.path_permission.no_write --or component.path_permission
		printf "%s" "$_flag_symbol_no_write"
		return 0
	end
	
	# Print default if --always.
	if [ -n "$_flag_always" ]
		promptfessional color component.path_permission
		printf "%s" "$_flag_symbol"
		return 0
	end
	
	return 1
end

