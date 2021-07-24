# Promptfessional | Copyright (C) 2021 eth-p
# Your flexible and highly-customizable fish shell prompt.
#
# Documentation: https://github.com/eth-p/fish-promptfessional/tree/master/docs
# Repository:    https://github.com/eth-p/fish-promptfessional
# Issues:        https://github.com/eth-p/fish-promptfessional/issues
#
function promptfessional
    __promptfessional_fn_"$argv[1]" $argv[2..-1]
    return $status
end

function __promptfessional_fn_util
    __promptfessional_util_"$argv[1]" $argv[2..-1]
    return $status
end

# Ends the current section, printing its components.
function __promptfessional_fn_end --description "Ends a declared prompt section."
  __promptfessional_end_section
  set_color normal
end

# Declares the start of a prompt section.
# This will implicitly end the previous prompt section, if there is one.
function __promptfessional_fn_section --description "Declares the start of a prompt section."
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

# Displays a component.
function __promptfessional_fn_show --description "Displays a prompt component."
    if not functions "promptfessional_component_"$argv[1] &>/dev/null
        echo "Unknown promptfessional component: $argv[1]" 1>&2
        return 1
    end

    set -l text (promptfessional_component_"$argv[1]" $argv[2..-1])
    if [ "$text" != "" ]
      set -g __promptfessional_current_section_parts $__promptfessional_current_section_parts "$text"
    end
end

# Declares the start of a prompt section.
# This will implicitly end the previous prompt section, if there is one.
function __promptfessional_fn_literal --description "Displays a prompt literal."
	set -l literal "$argv[1]"

	promptfessional util template (printf (string replace --all "%" "%%" "$literal")) \
		"arrow" "$__promptfessional_section_arrow_symbol"
end

# Enables a prompt setting.
function __promptfessional_fn_enable --description "Enables a prompt feature."
	switch $argv[1]
		case "arrow"
			set -g __promptfessional_section_arrow_symbol (printf "\uE0B0")
			set -g __promptfessional_section_arrow_begin true

		case "*"
			echo "unknown prompfessional feature: $argv[1]" 1>&2
			return 1
	end
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
function __promptfessional_fn_color --description "Gets or sets a prompt color."
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
				__promptfessional_color_extract $color \
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

# ----------------------------------------------------------------------------------------------------------------------
# UTILITY FUNCTIONS
# ----------------------------------------------------------------------------------------------------------------------

function __promptfessional_util_ansi_strip --description "Strips ANSI Colors from a string."
	string replace --all --regex "\x1B(?:\[[\d;]*[a-zA-Z]|\(B)" "" -- $argv
	return $status
end

function __promptfessional_util_ansi_extract --description "Extracts ANSI Colors from a string."
	argparse 'last' 'first' 'foreground' 'background' 'sequences' 'unrendered' -- $argv
	
	set -l text $argv[1]
	set -l regex
	
	# Determine which regex to use.
	if [ -n "$_flag_foreground" ]
		set regex '\x1B\[(?:\d)*((?:3|9)(?:[0-79]|(?:8;(?:5;\d+|(?:2;\d+;\d+;\d+)))))[\d;]*m'
	else if [ -n "$_flag_background" ]
		set regex '\x1B\[(?:\d)*((?:4|10)(?:[0-79]|(?:8;(?:5;\d+|(?:2;\d+;\d+;\d+)))))[\d;]*m'
	else if [ -n "$_flag_sequences" ]
		set regex '((?:\x1B(?:\[[0-9;]*m|\(B))+)'
	else
		echo "promptfessional util ansi_extract: requires --foreground or --background" 1>&2
		return 2
	end
	
	# Determine whether to get the first or last match.
	if [ -n "$_flag_first" ]
		set regex "^.*?$regex"
	else if [ -n "$_flag_last" ]
		set regex "^.*$regex"
	else
		echo "promptfessional util ansi_extract: requires --first or --last" 1>&2
		return 2
	end
	
	# Perform the match.
	set -l matches (string match --regex -- "$regex" "$text")
	if [ $status -ne 0 ]
		return 1
	end
	
	# Print the result.
	if [ -n "$_flag_sequences" ]
		if [ -n "$_flag_unrendered" ]
			printf "%s" (string replace -- (printf "\x1B") "\\x1B" "$matches[2]")
		else
			printf "%s" "$matches[2]"
		end
	else
		if [ -n "$_flag_unrendered" ]
			printf "%s" "$matches[2]"
		else
			printf "\x1B[%sm" "$matches[2]"
		end
	end
	
	return 0
end


function __promptfessional_util_seq --description "A faster version of the seq command."
	argparse 'step=' -- $argv
	
	set -l start $argv[1]
	set -l finish $argv[2]
	[ -n "$_flag_step" ] || set _flag_step 1
	
	while [ $start -le $finish ]
		echo $start
		set start (math $start + $_flag_step)
	end
end

function __promptfessional_util_template --description "Replaces template variables."
	argparse 'this-is-reserved' -- $argv
	
	set -l template $argv[1]
	set -l index
	
	# Escape backslashes in the template.
	set template (string replace --all -- "\\" "\\\\" "$template")
	
	# Fill in template variables.
	for index in (promptfessional util seq 2 (count $argv) --step=2)
		set -l var (string replace --all -- "." "\\." $argv[$index])
		set -l val $argv[(math $index + 1)]
		set -l val (string replace --all --regex -- "([\\\${])" "\\\\\$1" $argv[(math $index + 1)])
		
		set -l replacement "\${1}$val\${3}"
		if [ -z "$val" ]
			# If the value is empty, discard the padding symbols.
			set replacement ""
		end
		
		set template (
			string replace --all --regex -- \
			"(?!\\\\)\{([^a-zA-Z0-9\.]*)($var)([^a-zA-Z0-9\.]*)\}" "$replacement" \
			"$template"
		)
	end
	
	echo "$template"
end

# ----------------------------------------------------------------------------------------------------------------------
# INTERNAL FUNCTIONS
# ----------------------------------------------------------------------------------------------------------------------

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
    set -l text_no_ansi (promptfessional util ansi_strip "$text")
    set -l pattern "$__promptfessional_current_section_pattern"

    # If the pattern ends with a space and the section ends with a space, don't print the last pattern space.
    if [ (string sub --start=-1 "$pattern") = " " ] \
    && [ (string sub --start=-1 "$text_no_ansi") = " " ]
		set pattern (string sub --length=(math (string length "$pattern") - 1) "$pattern")
	end
    
	# Print the powerline arrow if enabled.
	if [ -n "$__promptfessional_section_arrow_symbol" ]
		set -l arrow_color ""
		
		# Get the current section's initial background color.
		# First, we'll try to parse out an ANSI background color escape sequence.
		set -l text_background (promptfessional util ansi_extract "$text" --first --background --unrendered)
		if [ $status -eq 0 ]
			# If we found a background color, we swap it to a foreground color and enter reverse mode.
			switch "$text_background"
				case "4*"
					set arrow_color (printf "\x1B[7;3%sm" (string sub --start=2 -- "$text_background"))
					
				case "10*"
					set arrow_color (printf "\x1B[7;9%sm" (string sub --start=3 -- "$text_background"))
			end
		else
			# If we didn't, let's just use the section background color.
			set -l arrow_color_name (string replace -- "--background=" "" \
				(promptfessional color "section.$__promptfessional_current_section" --or "section" --print))

			if [ "$arrow_bg_color" = "normal" ]
				set arrow_color_name
			end

			set arrow_color (set_color --reverse $arrow_color_name)
		end

		# Skip the first arrow, since it's not joining any sections together.
		if [ "$__promptfessional_section_arrow_begin" = "true" ]
			set __promptfessional_section_arrow_begin false
		else
			# Print the arrow.
			printf "%s%s%s%s" \
				"$arrow_color" \
				"$__promptfessional_section_arrow_lastbg" \
				"$__promptfessional_section_arrow_symbol" \
				(set_color normal)
		end
	end

    # Print the section.
    set -l pattern "$color"(string replace "%s" "%s$color" "$pattern")
    printf "$pattern" "$text"

    # Clear the section data.
    set __promptfessional_current_section ''
end

# INTERNAL:
# Extracts set_color arguments and filters them.
function __promptfessional_color_extract
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
