# Default theme for promptfessional.
#
# Themes:
#   dark :: For dark terminals.
function __promptfessional_theme
    argparse 'default' -- $argv
    set -l set "--set"
    
    # If the --default flag is passed, only set colors if we need to.
    if [ -n "$_flag_default" ]
		if [ "$__promptfessional_theme_init" = "1" ]
			return 0
		end
		set -g __promptfessional_theme_init 1
		set set "--set-default"
	end
	
	switch $argv[1]
	case "dark"
		
		# Sections
		promptfessional color "$set" section.status --background='ffffff'
		promptfessional color "$set" section.path --background='333333'
	
		# Status
		promptfessional color "$set" component.jobs '0066aa'
		promptfessional color "$set" component.sudo '009900' --bold
		promptfessional color "$set" component.status.error 'ff0000' --bold
		promptfessional color "$set" component.status.ok 'normal'
		
		# Path
		promptfessional color "$set" component.path '999999'
		promptfessional color "$set" component.path.current 'ffffff' --bold
		
		# Git
		promptfessional color "$set" git.clean --background='00ff00' 'ffffff'
		promptfessional color "$set" git.dirty --background='00ff00' 'ffffff'
		promptfessional color "$set" git.staged --background='ff9900' 'ffffff'
		promptfessional color "$set" git.unstaged --background='ff0000' 'ffffff'
	end
end
