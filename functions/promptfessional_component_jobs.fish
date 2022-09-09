# Prompt Component: Jobs
# Displays a "%" if there are any suspended background jobs.
#
# Options:
#   --with-count  :: Show the number of jobs.
#   --symbol      :: The symbol to display.    (default: %)
#
# Colors:
#   component.jobs        :: The color of the jobs indicator.
#   component.jobs.count  :: The color of the jobs count.
function promptfessional_component_jobs
	argparse 'with-count' 'symbol=' -- $argv
	[ -n "$_flag_symbol" ] || set _flag_symbol '%'
	
	# If there aren't any jobs, just return.
	if not jobs -q
		return 1
	end
	
	# Print the jobs indicator (and number of jobs).
	promptfessional color component.jobs
	printf "%s" "$_flag_symbol"
	
	if [ -n "$_flag_with_count" ]
		promptfessional color component.jobs.count --or=component.jobs
		printf "%s" (string trim -- (jobs -p | wc -l))
	end
end

set -g __promptfessional_uid (id -u)

