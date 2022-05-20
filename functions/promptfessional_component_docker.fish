# Prompt Component: Docker
# Displays the current docker context.
#
# Options:
#   --only-non-default    :: Only show if not the default context.
#   --symbol              :: The symbol to display (default "").
#
# Colors:
#   component.docker  :: Used for the docker context.
function promptfessional_component_docker
    argparse 'only-non-default' 'symbol=' -- $argv

    set -l current_context_name "$DOCKER_CONTEXT"

    # Handle default/unset Docker context.
    if [ -z "$current_context_name" ]
        if [ -n "$_flag_only_non_default" ]
            return 0
        end

        set current_context_name "default"
    end

    # Display.
    promptfessional color component.docker
    if [ -n "$_flag_symbol" ]
        printf "%s " "$_flag_symbol"
    end

    printf "%s" "$current_context_name"
end

