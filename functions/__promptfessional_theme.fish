# Default theme for promptfessional.
#
# Themes:
#   dark   :: For dark terminals.
#   light  :: For light terminals.
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
		promptfessional color "$set" component.private '333333'
		promptfessional color "$set" component.status.error 'ff0000' --bold
		promptfessional color "$set" component.status.ok 'normal'
		
		# Path
		promptfessional color "$set" component.path '999999'
		promptfessional color "$set" component.path.current 'ffffff' --bold
		promptfessional color "$set" component.path.current.ro 'ff9999' --bold
		
		promptfessional color "$set" component.path_permission '999999'
		promptfessional color "$set" component.path_permission.no_read 'ff0000' --bold
		promptfessional color "$set" component.path_permission.no_write 'cc0000'
		
		# Git
		promptfessional color "$set" git.clean --background='99cc00' 'ffffff'
		promptfessional color "$set" git.staged --background='dd7700' 'ffffff'
		promptfessional color "$set" git.unstaged --background='bb1100' 'ffffff'
		promptfessional color "$set" git.untracked --background='99cc00' 'ffffff'

	case "light"

		# Sections
		promptfessional color "$set" section.status --background='999'
		promptfessional color "$set" section.path --background='eeeeee'
	
		# Status
		promptfessional color "$set" component.jobs '0066aa'
		promptfessional color "$set" component.sudo '009900' --bold
		promptfessional color "$set" component.private 'cccccc'
		promptfessional color "$set" component.status.error 'ff0000' --bold
		promptfessional color "$set" component.status.ok 'normal'
		
		# Path
		promptfessional color "$set" component.path '666666'
		promptfessional color "$set" component.path.current '333333' --bold
		promptfessional color "$set" component.path.current.ro 'ff3333' --bold
		
		promptfessional color "$set" component.path_permission '999999'
		promptfessional color "$set" component.path_permission.no_read 'ff0000' --bold
		promptfessional color "$set" component.path_permission.no_write '660000'
		
		# Git
		promptfessional color "$set" git.clean --background='00dd00' 'ffffff'
		promptfessional color "$set" git.staged --background='dd7700' 'ffffff'
		promptfessional color "$set" git.unstaged --background='dd0000' 'ffffff'
		promptfessional color "$set" git.untracked --background='00dd00' 'ffffff'

	end
end
