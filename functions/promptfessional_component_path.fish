# Prompt Component: Path
# Displays the path to the current directory.
#
# Options:
#   --abbrev-parents  :: Only show the first letter of parent directories.
#   --collapse-home   :: Replaces "$HOME" with "~".
#
# Colors:
#   component.path             :: Used for parent directories.
#   component.path.current     :: Used for the current directory.
#   component.path.current.ro  :: Used for the current directory when the user doesn't have write permissions.
function promptfessional_component_path
    argparse -i 'decoration=' 'collapse-home' 'abbrev-parents' -- $argv
    set -l deco_args $argv
    set -l color ''
    
    # Get the current directory.
    set -l pwd (pwd)
    set -l display_pwd "$pwd"
    
    # If '--collapse-home' is passed, replace "$HOME/" with ~/
    if [ -n "$_flag_collapse_home" ]
    	set -l pwd_starts (string sub --length=(math (string length "$HOME") + 1) -- "$pwd")
    	if [ "$pwd_starts" = "$HOME" ]
    		set display_pwd "~"
    	else if [ "$pwd_starts" = "$HOME/" ]
    		set display_pwd "~/"(string sub --start=(math (string length "$HOME") + 2) -- "$pwd")
    	end
    end
    
    # Configure dynamic dispatch.
	set -l render_parent __promptfessional_component_path__render_parent
	[ -n "$_flag_abbrev_parents" ] && set render_parent __promptfessional_component_path__render_parent_abbreviated
    
    # Walk through the path.
    set -l dirs (string split -- '/' "$display_pwd")
	set -l dir_path "/"
	set -l first_separator ""
	set -l rendered_segment
	set -l rendered_segment_decoration
	
	switch "$dirs[1]"
		case "~"
			set dir_path "$HOME"
			set first_separator "/"
			
		case "" # If it's empty, our first directory is `/`.
			set dirs[1] "/"
			set dir_path ""
	end
	
	# If the topmost directory is empty, we're dealing with a pwd ending with a slash.
	# This should be removed.
	if [ "$dirs[-1]" = "" ]
		set dirs $dirs[1..-2]
	end

	# Render the parents.
	if [ (count $dirs) -gt 1 ]
		set -l segment $dirs[1]
		
		"$render_parent" "$segment" ""
		for segment in $dirs[2..-2]
			set dir_path "$dir_path/$segment"
			"$render_parent" "$segment" "/"
		end
		
		set dir_path "$dir_path/$dirs[-1]"
	end
		
	# Render the current directory.
	if [ -w "$pwd" ]
		set color (promptfessional color component.path.current)
	else
		set color (promptfessional color component.path.current.ro --or component.path.current)
	end
	
	__promptfessional_component_path__push "$color$dirs[-1]"
	
	# Cache color variables.
	set -l color (promptfessional color component.path)
	set -l color_reset (set_color normal)
	set color_reset (printf "%s%s%s" "$color_reset" (promptfessional section --current-color) "$path_color")

	# Print the path.
	set -l i
	set -l deco
	printf "%s" "$color"
	for i in (promptfessional util seq 1 (count $rendered_segment))
		if [ -n "$deco" ]
			printf " "
		end
		
		# Print the current segment.
		[ $i -eq 2 ] && printf "$first_separator"
		printf "%s" "$rendered_segment[$i]"
		
		# If there's a decoration, render that.
		set deco "$rendered_segment_decoration[$i]"
		if [ -n "$deco" ]
			printf "%s %s%s" "$color_reset" "$deco" "$color_reset"
		end
	end
end

# Renders an abbreviated path item.
function __promptfessional_component_path__render_parent_abbreviated --no-scope-shadowing
	# If the path starts with a '.', abbreviate to 2 characters.
	# Otherwise, abbreviate to 1 character.
	set -l __abbreviated ""
	if [ (string sub --length=1 -- "$argv[1]") = "." ]
		set __abbreviated (string sub --length=2 -- "$argv[1]")
	else
		set __abbreviated (string sub --length=1 -- "$argv[1]")
	end
	
	__promptfessional_component_path__push "$__abbreviated$argv[2]"
end

# Renders a path item.
function __promptfessional_component_path__render_parent --no-scope-shadowing
	__promptfessional_component_path__push "$argv[1]$argv[2]"
end

# Pushes a path to the rendered segment array.
function __promptfessional_component_path__push --no-scope-shadowing
	set rendered_segment $rendered_segment $argv[1]
	
	# If there are any path decorations, try to render them as well.
	if [ (count $_flag_decoration) -gt 0 ]
		set -l deco_fn
		set -l deco_str
		
		# Run every decoration function.
		for deco_fn in $_flag_decoration
			set -l deco_val ($deco_fn "$dir_path" $deco_args)
			if [ $status -eq 0 ]
				set deco_str "$deco_str$deco_val" 
			end
		end
		
		# If the decoration string isn't empty, append the path color to the end.
		if [ -n "$deco_str" ]
			set -l path_color (promptfessional color component.path)
			set deco_str "$deco_str"
		end
		
		# Add the decoration string to the segment array.
		set rendered_segment_decoration $rendered_segment_decoration "$deco_str"
	end
end
