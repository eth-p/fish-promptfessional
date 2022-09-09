# Prompt Component: Hostname
# Displays the current hostname.
#
# Options:
#   --remove-suffix  :: Strip this text from the right of the hostname. (default: .local)
#   --only-remote    :: Only show on a remote host (i.e. SSH_CONNECTION, SSH_TTY, or SSH_CLIENT are set)
#
# Colors:
#   component.hostname  :: Used for the hostname.
function promptfessional_component_hostname
	argparse 'only-remote' 'remove-suffix=' -- $argv

	[ -n "$_flag_remove_suffix" ] || set _flag_remove_suffix '.local'

	# Stop if local machine and '--only-remote'
	if [ -n "$_flag_only_remote" ]
		if [ -z "$SSH_TTY" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_CONNECTION" ]
			return 0
		end
	end

	# Right Strip
	set -l hostname_str "$__promptfessional_hostname"
	set -l hostname_len (string length -- "$hostname_str")
	set -l suffix_len (string length -- "$_flag_remove_suffix")

	if [ "$hostname_len" -gt "$suffix_len" ] && \
		[ (string sub --start=(math $hostname_len - $suffix_len + 1) -- "$hostname_str") = "$_flag_remove_suffix" ]
		set hostname_str (string sub --length=(math $hostname_len - $suffix_len) -- "$hostname_str")
	end

	promptfessional color component.hostname
	printf "%s" "$hostname_str"
end

set -g __promptfessional_hostname "$hostname"

