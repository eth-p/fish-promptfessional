# Prompt Decoration: Git
# Displays the current git information.
#
# Options:
#   --git-hide-branch      :: Hides any of these branches.
#   --git-symbol-branch    :: Changes the symbol used to represent a branch.
#   --git-symbol-head      :: Changes the symbol used to represent a detached head.
#   --git-symbol-staged    :: Changes the symbol used to represent staged changes.
#   --git-symbol-unstaged  :: Changes the symbol used to represent unstaged changes.
#   --git-use-cache        :: Enables experimental caching support for a faster prompt.
#   --git-long-hash        :: Uses long hashes.
#
# Colors:
#   git.clean     :: Used when the worktree is clean.
#   git.dirty     :: Used when there are no unstaged changed.
#   git.staged    :: Used when there are staged but uncomitted changes.
#   git.unstaged  :: Used when there are modified but unstaged files.
function promptfessional_decoration_git
    if ! [ -e "$argv[1]/.git" ]
    	return 1
    end
    
    argparse -i 'git-hide-branch=+' 'git-use-cache' 'git-long-hash' \
    	'git-symbol-branch=' 'git-symbol-head=' \
    	'git-symbol-staged=' 'git-symbol-unstaged=' \
    	-- $argv
    
	# Get info.
	set -l git_head ""
	set -l git_branch ""
	set -l git_conflict false 
	set -l git_dirty false
	set -l git_staged false
	set -l git_unstaged false
	__promptfessional_git_info "$argv[1]" "$_flag_git_use_cache" || return 1
	
	# If the branch is one of the default branches, don't show the name.
	set -l branch
	set -l deco_branch "$git_branch"
	for branch in $_flag_git_hide_branch
		if [ "$git_branch" = "$branch" ]
			set deco_branch ""
		end
	end
	
	# Convert the long commit hash into a short one.
	if [ -z "$_flag_git_long_hash" ]
		set git_head (string sub --length=7 -- "$git_head")
		set git_merge_head (string sub --length=7 -- "$git_merge_head")
	end

	# Set default symbols.
	[ -n "$_flag_git_symbol_branch" ] || set _flag_git_symbol_branch "⎇ "
	[ -n "$_flag_git_symbol_head" ]   || set _flag_git_symbol_head "➦ "
	[ -n "$_flag_git_symbol_staged" ] || set _flag_git_symbol_staged "~"
	[ -n "$_flag_git_symbol_unstaged" ] || set _flag_git_symbol_unstaged "*"
	
	# Determine what to print.
	set -l deco_print
	if [ -z "$git_branch" ]
		if "$git_is_rebasing"
			# If we're rebasing, mention the rebase.
			set deco_print "$_flag_git_symbol_head""rebase($git_head)"		
		else
			# If we just aren't in a branch (e.g. detached HEAD), show the commit hash.
			set deco_print "$_flag_git_symbol_head$git_head"
		end
	else
		if "$git_is_merging"
			# If we're merging, mention the merge.
			set deco_print "$_flag_git_symbol_branch$deco_branch"
			if [ -n "$deco_branch" ]
				set deco_print "$deco_print "
			end
			
			set deco_print "$deco_print""merge($git_merge_head)"	
		else
			# If we're in a branch, show the branch.
			set deco_print "$_flag_git_symbol_branch$deco_branch"
		end
	end
	
	# Determine the color.
	set -l color ""
	if $git_unstaged
    	set color (promptfessional color git.unstaged)
	else if $git_staged
    	set color (promptfessional color git.staged)
	else if $git_dirty
   		set color (promptfessional color git.dirty)
	else
    	set color (promptfessional color git.clean)
	end
	
	# Print git info.
	printf "%s %s" "$color" "$deco_print"
	if $git_unstaged; printf "%s" "$_flag_git_symbol_unstaged"; end
	if $git_staged; printf "%s" "$_flag_git_symbol_staged"; end
	printf " "
    
    return 0
end

# Gets info about the current git repo, setting local variables.
#
# Arguments:
#   $1 :: The working directory.
#   $2 :: Whether or not to use a cache to speed up this command.
#
# Variables:
#   git_unstaged  :: There are unstaged modifications or deletions.#   git_toplevel    :: The repo directory.
#   git_branch      :: The name of the current branch.
#   git_conflict    :: A file has a merge conflict.
#   git_dirty     :: The worktree is dirty.
#   git_head        :: The full commit hash of the HEAD.
#   git_merge_head  :: The full commit hash of the merge HEAD. (will be empty if not merging)
#   git_staged      :: There are staged changes.
#   git_unstaged    :: There are unstaged modifications or deletions.
#   git_is_merging  :: Git is in the middle of a merge operation.
#   git_is_rebasing :: Git is in the middle of a rebase operation.
function __promptfessional_git_info --no-scope-shadowing
	set git_toplevel (git -C "$argv[1]" rev-parse --show-toplevel 2>/dev/null) || return 1
	set git_conflict false 
	set git_dirty false
	set git_staged false
	set git_unstaged false
	set git_merge_head ""
	set git_is_rebasing false
	set git_is_merging false

	# If the cache is enabled and the key matches, use the cached vars.
	set -l __git_cachekey ''
	set -l __git_cachevars "conflict" "dirty" "staged" "unstaged" "head" "branch" "merge_head" "is_rebasing" "is_merging"
	if [ "$argv[2]" = "--git-use-cache" ]
		set -l __git_lastmod (stat -c "%Y" . 2>/dev/null || stat -f "%m" .)
		set __git_cachekey "$git_toplevel:$git_branch:$__git_lastmod"
		if [ "$__promptfessional_git_cache_key" = "$__git_cachekey" ]
			set -l key
			for key in $__git_cachevars
				eval "set git_$key "'$'"__promptfessional_git_cache_$key" 
			end
			return 0
		end
	end
	
	# Get the branch name, head revision, and status about rebase/merge. 
	set git_branch (git -C "$argv[1]" branch --show-current 2>/dev/null)
	set git_head (git -C "$argv[1]" rev-parse HEAD 2>/dev/null)
	
	if git -C "$argv[1]" rebase --show-current-patch &>/dev/null
		set git_is_rebasing true
	end
	
	set git_merge_head (git -C "$argv[1]" rev-list -1 MERGE_HEAD 2>/dev/null)
	if [ $status -eq 0 ]
		set git_is_merging true
	end


	# Determine the status of the worktree.
	while read -l __git_file_status
		switch $__git_file_status
		case "UU"
			set git_conflict true
		case "\?\?"
			set git_dirty true
		case "? "
			set git_staged true
		case " ?"
			set git_unstaged true
		case "??"
			set git_staged true
			set git_unstaged true
		end
	end < (git -C $argv[1] status -s | sed 's/^\(..\) [^ ].*$/\1/' | psub)

	# If the cache is enabled, update the cache.
	if [ "$argv[2]" = "--git-use-cache" ]
		set -l key
		for key in $__git_cachevars
			eval "set -g __promptfessional_git_cache_$key "'$'"git_$key" 
		end
		set -g __promptfessional_git_cache_key "$__git_cachekey"
	end

end
