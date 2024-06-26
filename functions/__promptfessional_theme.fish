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
		promptfessional color "$set" section.cmdtime --background='dddddd'
		promptfessional color "$set" section.path --background='333333'

		# Status
		promptfessional color "$set" component.jobs '0066aa'
		promptfessional color "$set" component.sudo '009900' --bold
		promptfessional color "$set" component.private '333333'
		promptfessional color "$set" component.status.error 'ff0000' --bold
		promptfessional color "$set" component.status.ok 'normal'
		promptfessional color "$set" component.venv ccf --background='4b8bbe'
		promptfessional color "$set" component.cmdtime '666666'
		promptfessional color "$set" component.cmdtime.slow 'aa6666'
		promptfessional color "$set" component.cmdtime.unit '888888'
		promptfessional color "$set" component.datetime '555555'
		promptfessional color "$set" component.datetime.extra '444444'
		promptfessional color "$set" component.datetime.date '555555'
		promptfessional color "$set" component.datetime.time '777777'

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

		# Docker
		promptfessional color "$set" component.docker --background='384d54' 'cccccc'

		# Java
		promptfessional color "$set" component.java --background='a86616' 'cccccc'

	case "light"

		# Sections
		promptfessional color "$set" section.status --background='999'
		promptfessional color "$set" section.cmdtime --background='bbb'
		promptfessional color "$set" section.path --background='eeeeee'

		# Status
		promptfessional color "$set" component.jobs '0066aa'
		promptfessional color "$set" component.sudo '009900' --bold
		promptfessional color "$set" component.private 'cccccc'
		promptfessional color "$set" component.status.error 'ff0000' --bold
		promptfessional color "$set" component.status.ok 'normal'
		promptfessional color "$set" component.venv ccf --background='4b8bbe'
		promptfessional color "$set" component.cmdtime '333333'
		promptfessional color "$set" component.cmdtime.slow 'aa3333'
		promptfessional color "$set" component.cmdtime.unit '444444'
		promptfessional color "$set" component.datetime '999999'
		promptfessional color "$set" component.datetime.extra '777777'
		promptfessional color "$set" component.datetime.date '999999'
		promptfessional color "$set" component.datetime.time 'bbbbbb'

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

		# Docker
		promptfessional color "$set" component.docker --background='9de7fd' '333333'

		# Java
		promptfessional color "$set" component.java --background='f89820' '000000'

	end
end

