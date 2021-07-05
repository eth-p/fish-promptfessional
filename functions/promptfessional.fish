# Promptfessional
# Your flexible and highly-customizable fish shell prompt.
#
# Usage:
#   function fish_prompt
#     promptfessional section status --delimiter=' '
#       promptfessional show status
#       promptfessional show jobs
#       promptfessional show sudo
#
#     promptfessional section path --pattern=' %s'
#       promptfessional show path \
#         --collapse-home \
#         --abbrev-parents \
#         --decoration promptfessional_decoration_git \
#         --git-hide-branch main \
#         --git-hide-branch master 
#         
#     promptfessional end
#     promptfessional literal " "
#   end
#
# Configuring Colors:
#   promptfessional color --set COLOR_NAME --background=BG FG
#   
function promptfessional
    __promptfessional_"$argv[1]" $argv[2..-1]
    return $status
end

function __promptfessional_end
  __promptfessional_end_section
  set_color normal
end

function __promptfessional_end_section --description "Prints the current section."
    if [ -z "$__promptfessional_current_section" ] || [ (count $__promptfessional_current_section_parts) -eq 0 ]
        return 1
    end

    # Join together all the parts in the section.
    set -l reset (set_color normal)
    set -l color "$__promptfessional_current_section_color"

    set -l delimiter "$reset$color$__promptfessional_current_section_delimiter"
    set -l text (string join "$delimiter" -- $__promptfessional_current_section_parts)

    # Print the section.
    set -l pattern "$color"(string replace "%s" "%s$color" "$__promptfessional_current_section_pattern")
    printf "$pattern" "$text"

    # Clear the section data.
    set __promptfessional_current_section ''
end

function __promptfessional_section
	__promptfessional_theme --default dark
    __promptfessional_end_section

    argparse 'pattern=' 'delimiter=' -- $argv
    [ -n "$_flag_pattern" ] || set _flag_pattern " %s "

    set -g __promptfessional_current_section $argv[1]
    set -g __promptfessional_current_section_parts
    set -g __promptfessional_current_section_pattern "$_flag_pattern"
    set -g __promptfessional_current_section_delimiter "$_flag_delimiter"
    set -g __promptfessional_current_section_color (promptfessional color "section.$argv[1]" --or "section")
end

function __promptfessional_show
    if not functions "promptfessional_component_"$argv[1] &>/dev/null
        echo "Unknown promptfessional component: $argv[1]" 1>&2
        return 1
    end

    set -l text (promptfessional_component_"$argv[1]" $argv[2..-1])
    if [ "$text" != "" ]
      set -g __promptfessional_current_section_parts $__promptfessional_current_section_parts "$text"
    end
end

function __promptfessional_literal
    printf "%s" $argv[1]
end

# Promptfessional: promptfessional color
#
# Get or set a prompt color.
# Promptfessional uses its own system for fetching colors to use.
# Under the hood, this uses fish's set_color function.
#
# Options:
#   --set            :: Sets the color.
#   --set-default    :: Sets the color if it's not already set.
#   --or=COLOR_NAME  :: If the color is not set, use this color instead.
#
# Example:
#   promptfessional color --set component.path --background=normal green   # Set the path to green.
#   promptfessional color --set section.status --background=white
function __promptfessional_color
    argparse -i 'set' 'set-default' 'or=' -- $argv

    set -l name (string replace --all -- '.' '_' $argv[1])
    set -l value $argv[2..-1]
	set -l color
	eval "set color \$__promptfessional_colors__$name"
    
    # If --set-default is passed and the color is defined, return.
    if [ -n "$_flag_set_default" ] && [ -n "$color" ]
    	return
	end

	# If neither --set nor --set-default were passed, get the color.
    if [ -z "$_flag_set" ] && [ -z "$_flag_set_default" ]
        if [ -z "$color" ]
        	if [ -n "$_flag_or" ]
        		__promptfessional_color "$_flag_or"
        		return $status
        	end
        	return 1
        end
        
        set_color $color
        return $result_status
    end

	# Otherwise, set the color.
    set -g "__promptfessional_colors__$name" $value
end
