# Prompt Component: java
# Displays the Java version in the prompt.
#
# Options:
#   --pattern	   :: The pattern to use.            (default: "java {version}")
#   --show-default :: Still show if JAVA_HOME unset  (default: false)
#
# Colors:
#   component.java  :: The color of the java prompt.
function promptfessional_component_java
	argparse pattern= show-default -- $argv
	set -l java_version
	
	# Don't display the component if not inside a virtual environment.
	if [ -z "$_flag_show_default" ] && [ -z "$JAVA_HOME" ]
		return 1
	end

	# Determine the current Java version.
	if not _promptfessional_var_cache \
		--cache-namespace="promptfessional_component_java" \
		--cache-key="JAVA_HOME=$JAVA_HOME" \
		java_version
		
		set -l java_bin "java"
		if [ -n "$JAVA_HOME" ]
			set java_bin "$JAVA_HOME/bin/java"
		end

		set java_version ("$java_bin" -version 2>&1 \
			| string match --regex --groups-only 'build ([\d.]+)' \
			| head -n1 \
			| string replace --regex '^1\.(\d)' '$1' \
			| string replace --regex '^(\d+)\..*$' '$1'
		)

		_promptfessional_var_cache --update-cache \
			--cache-namespace="promptfessional_component_java" \
			--cache-key="JAVA_HOME=$JAVA_HOME" \
			java_version
	end
	
	# Render the component.
	[ -n "$_flag_pattern" ] || set _flag_pattern 'java {version}'
	promptfessional color "component.java.$java_version" --or component.java
	promptfessional util template "$_flag_pattern" \
		version "$java_version"
end

