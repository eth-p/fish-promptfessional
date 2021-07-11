function promptfessional_default_prompt
    promptfessional section status --delimiter=' '
        promptfessional show status
        promptfessional show private
        promptfessional show jobs
        promptfessional show sudo

    promptfessional section path --pattern=' %s '
        promptfessional show path \
        	--collapse-home \
        	--abbrev-parents \
        	--decoration promptfessional_decoration_git \
        	--git-hide-branch main \
        	--git-hide-branch master 

    promptfessional end
    promptfessional literal " "
end
