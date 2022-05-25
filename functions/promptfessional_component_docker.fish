# Prompt Component: Docker
# Displays the current docker context.
#
# Options:
#   --symbol              :: The symbol to display (default "").
#   --hide-context [name] :: Hides the component if this context is used.
#   --hide-default        :: Hides the component if the default context is used.
#   --show-unexported     :: Shows the component even when DOCKER_CONTEXT is not exported.
#
# Colors:
#   component.docker  :: Used for the docker context.
function promptfessional_component_docker
    argparse 'symbol=' 'show-unexported' 'hide-default' 'hide-context=+' -- $argv
    set -l current_context_name "$DOCKER_CONTEXT"
    set -l current_context_display "$current_context_name"

    if set --query DOCKER_CONTEXT
        if not set --query --export DOCKER_CONTEXT && [ -z "$_flag_show_unexported" ]
            # Don't show anything if the variable is set but unexported.
            return 0
        end

        if [ -z "$DOCKER_CONTEXT" ]
            set current_context_display "(empty)"
        end
    else
        if [ -n "$_flag_hide_default" ]
            # Don't show anything if '--hide-default' and not set.
            return 0
        end

        set current_context_display "(default)"
    end

    # Return early if the context is specified in '--hide-context'.
    if contains "$current_context_name" $_flag_hide_context
        return 0
    end

    # Display.
    promptfessional color component.docker
    if [ -n "$_flag_symbol" ]
        printf "%s " "$_flag_symbol"
    end

    printf "%s" "$current_context_display"
end

