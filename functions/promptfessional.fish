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

# Ends the current section, printing its components.
function __promptfessional_end
  __promptfessional_end_section
  set_color normal
end

# INTERNAL:
# Joins together all the rendered components and prints them.
function __promptfessional_end_section --description "Prints the current section."
    if [ -z "$__promptfessional_current_section" ] || [ (count $__promptfessional_current_section_parts) -eq 0 ]
        return 1
    end

    # Join together all the parts in the section.
    set -l reset (set_color normal)
    set -l color "$__promptfessional_current_section_color"

    set -l delimiter "$reset$color$__promptfessional_current_section_delimiter"
    set -l text (string join "$delimiter" -- $__promptfessional_current_section_parts)
    set -l text_no_ansi (string replace --all --regex "\x1B(?:\[[\d;]*[a-zA-Z]|\(B)" "" "$text")
    set -l pattern "$__promptfessional_current_section_pattern"

    # If the pattern ends with a space and the section ends with a space, don't print the last pattern space.
    if [ (string sub --start=-1 "$pattern") = " " ] \
    && [ (string sub --start=-1 "$text_no_ansi") = " " ]
		set pattern (string sub --length=(math (string length "$pattern") - 1) "$pattern")
	end
    
    # Print the section.
    set -l pattern "$color"(string replace "%s" "%s$color" "$pattern")
    printf "$pattern" "$text"

    # Clear the section data.
    set __promptfessional_current_section ''
end

# Declares the start of a prompt section.
# This will implicitly end the previous prompt section, if there is one.
function __promptfessional_section --description "Declares the start of a prompt section."
    argparse 'pattern=' 'delimiter=' 'current-color' -- $argv

	# Argument: --get-color
	if [ -n "$_flag_current_color" ]
		printf "%s" "$__promptfessional_current_section_color"
		return 0
	end

	# Set the default colors and end the previous section.
	__promptfessional_theme --default dark
    __promptfessional_end_section

    # Default arguments.
    [ -n "$_flag_pattern" ] || set _flag_pattern " %s "

	# Initialize the section.
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
#   --set             :: Sets the color.
#   --set-default     :: Sets the color if it's not already set.
#   --only-foreground :: Only gets the foreground color.
#   --only-background :: Only gets the background color.
#   --only-attributes :: Only gets the attributes.
#   --print           :: Prints the color name instead of the code.
#   --or=COLOR_NAME   :: If the color is not set, use this color instead.
#
# Example:
#   promptfessional color --set component.path --background=normal green   # Set the path to green.
#   promptfessional color --set section.status --background=white
function __promptfessional_color
    argparse -i 'set' 'set-default' 'only-foreground' 'only-background' 'only-attributes' 'print' 'or=' -- $argv

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
        		__promptfessional_color "$_flag_or" \
        			$_flag_only_foreground $_flag_only_background $_flag_only_attributes
        		return $status
        	end
        	return 1
        end
        
		# If we're only trying to get the foreground/background/attributes, run it through
		# the color extraction function.
		if [ -n "$_flag_only_foreground$_flag_only_background$_flag_only_attributes" ]
			set color (
				__promptfessional__color_extract $color \
					$_flag_only_foreground $_flag_only_background $_flag_only_attributes
			)
		end

		# If we're only printing the color names, print them and exit early.
		if [ -n "$_flag_print" ]
			printf "%s\n" $color
			return 0
		end

        set_color $color
        return $result_status
    end

	# Otherwise, set the color.
    set -g "__promptfessional_colors__$name" $value
end

# INTERNAL:
# Extracts set_color arguments and filters them.
function __promptfessional__color_extract
	argparse 'b/background=' 'o/bold' 'd/dim' 'i/italics' 'r/reverse' 'u/underline' \
		'only-background' 'only-foreground' 'only-attributes' -- $argv
	
	# Set the defaults if missing the foreground or background.
	set -l foreground "$argv[1]"
	[ -n "$_flag_background" ] || set _flag_background "normal"
	[ -n "$foreground" ]       || set foreground "normal"

	# Swap the foreground and background if reverse is set.
	if [ -n "$_flag_reverse" ]
		set -l temp "$_flag_background"
		set _flag_background "$foreground"
		set foreground "$temp"
	end

	# Print.
	if [ -n "$_flag_only_foreground" ]
		echo "$foreground"
	end

	if [ -n "$_flag_only_background" ]
		echo "--background=$_flag_background"
	end

	if [ -n "$_flag_only_attributes" ]
		printf "%s\n" $_flag_bold $_flag_italics $_flag_dim $_flag_underline
	end
end

