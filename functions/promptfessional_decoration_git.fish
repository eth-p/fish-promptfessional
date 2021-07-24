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
#   --git-pattern-merge    :: The pattern to use for a merge operation.
#   --git-pattern-rebase   :: The pattern to use for a rebase operation.
#   --git-pattern-detached :: The pattern to use when on a detached head.
#   --git-pattern-branch   :: The pattern to use when on a branch.
#
# Colors:
#   git.clean      :: Used when the worktree is clean.
#   git.untracked  :: Used when there are untracked files.
#   git.staged     :: Used when there are staged but uncomitted changes.
#   git.unstaged   :: Used when there are modified but unstaged files.
function promptfessional_decoration_git
    if ! [ -e "$argv[1]/.git" ]
    return 0
    	return 1
    end
    
    argparse -i 'git-hide-branch=+' 'git-use-cache' 'git-long-hash' \
    	'git-pattern-merge=' 'git-pattern-rebase=' \
    	'git-pattern-detached=' 'git-pattern-branch=' \
    	'git-symbol-branch=' 'git-symbol-head=' \
    	'git-symbol-staged=' 'git-symbol-unstaged=' \
    	-- $argv
    
	# Get info.
	set -l git_head ""
	set -l git_branch ""
	set -l git_merge_head ""
	set -l git_rebase_head ""
	set -l git_rebase_todo ""
	set -l git_is_rebasing false
	set -l git_is_merging false
	set -l git_conflict false 
	set -l git_untracked false
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
		set git_rebase_head (string sub --length=7 -- "$git_rebase_head")
	end

	# Set default symbols.
	[ -n "$_flag_git_symbol_branch" ] || set _flag_git_symbol_branch "⎇ "
	[ -n "$_flag_git_symbol_head" ]   || set _flag_git_symbol_head "➦ "
	[ -n "$_flag_git_symbol_staged" ] || set _flag_git_symbol_staged "~"
	[ -n "$_flag_git_symbol_unstaged" ] || set _flag_git_symbol_unstaged "*"
	
	# Set default patterns.
	[ -n "$_flag_git_pattern_branch" ]   || set _flag_git_pattern_branch " {symbol}{branch}{status} "
	[ -n "$_flag_git_pattern_detached" ] || set _flag_git_pattern_detached " {symbol}{head}{status} "
	[ -n "$_flag_git_pattern_merge" ]    || set _flag_git_pattern_merge " {symbol}{branch_or_head }merge({merge_head}){status} "
	[ -n "$_flag_git_pattern_rebase" ]   || set _flag_git_pattern_rebase " {symbol}{branch_or_head }rebase({rebase_head}|{rebase_todo}){status} "
	
	# Generate the "{symbol}" and "{branch_or_head}" pattern variables.
	set -l deco_symbol "$_flag_git_symbol_branch"
	set -l deco_branch_or_head "$git_branch"
	if [ -z "$git_branch" ]
		set deco_symbol "$_flag_git_symbol_head" 
		set deco_branch_or_head "$git_head"
	end
	
	# Generate the "{status}" pattern variable.
	set -l deco_status ""
	if $git_unstaged; set deco_status "$deco_status$_flag_git_symbol_unstaged"; end
	if $git_staged;  set deco_status "$deco_status$_flag_git_symbol_staged"; end
	
	# Determine the correct pattern.
	set -l pattern
	if "$git_is_rebasing"
		set pattern "$_flag_git_pattern_rebase"
	else if "$git_is_merging"
		set pattern "$_flag_git_pattern_merge"
	else if [ -n "$git_branch" ]
		set pattern "$_flag_git_pattern_branch"
	else
		set pattern "$_flag_git_pattern_detached"
	end
	
	# Determine the color.
	set -l color ""
	if $git_unstaged
    	set color (promptfessional color git.unstaged)
	else if $git_staged
    	set color (promptfessional color git.staged)
	else if $git_untracked
   		set color (promptfessional color git.untracked)
	else
    	set color (promptfessional color git.clean)
	end
	
	# Fill out the pattern.
	set pattern (
		promptfessional util template -- "$pattern" \
			"symbol" "$deco_symbol" \
			"status" "$deco_status" \
			"branch_or_head" "$deco_branch_or_head" \
			"branch" "$deco_branch" \
			"head" "$git_head" \
			"merge_head" "$git_merge_head" \
			"rebase_head" "$git_rebase_head" \
			"rebase_todo" "$git_rebase_todo" \
			"color" "$color"
	)
	
	# Print the pattern.
	printf "%s%s" "$color" "$pattern"
    
    return 0
end

# Gets info about the current git repo, setting local variables.
#
# Arguments:
#   $1 :: The working directory.
#   $2 :: Whether or not to use a cache to speed up this command.
#
# Variables:
#   git_toplevel    :: The repo directory.
#   git_branch      :: The name of the current branch.
#   git_head        :: The full commit hash of the HEAD.
#   git_merge_head  :: The full hash of the commit being merged into the HEAD. (will be empty if not merging)
#   git_rebase_todo :: The number of steps remaining in the rebase.
#   git_rebase_head :: The full hash of the commit being rebased. (will be empty if not rebasing)
#   git_conflict    :: There are files that have merge conflicts.
#   git_staged      :: There are staged changes.
#   git_unstaged    :: There are unstaged modifications or deletions.
#   git_untracked   :: The worktree contains untracked files.
#   git_is_merging  :: Git is in the middle of a merge operation.
#   git_is_rebasing :: Git is in the middle of a rebase operation.
function __promptfessional_git_info --no-scope-shadowing
	set __git_revparsed (git -C "$argv[1]" rev-parse --show-toplevel --absolute-git-dir 2>/dev/null) || return 1

	set git_toplevel "$__git_revparsed[1]"
	set git_gitdir "$__git_revparsed[2]"
	set git_head ""
	set git_branch ""
	set git_merge_head ""
	set git_rebase_head ""
	set git_conflict false 
	set git_untracked false
	set git_staged false
	set git_unstaged false
	set git_is_rebasing false
	set git_is_merging false

	# If the cache is enabled and the key matches, use the cached vars.
	set -l __git_cachekey ''
	set -l __git_cachevars "conflict" "untracked" "staged" "unstaged" \
		"head" "branch" "merge_head" "rebase_head" "rebase_todo" \
		"is_rebasing" "is_merging"
	if [ "$argv[2]" = "--git-use-cache" ]
		set -l __git_lastmod (stat -c "%Y" "$argv[1]" "$git_gitdir" 2>/dev/null || stat -f "%m" "$argv[1]" "$git_gitdir")
		set __git_cachekey "$git_toplevel:$__git_lastmod"
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
		set git_rebase_todo (wc -l < "$git_gitdir/rebase-merge/git-rebase-todo" | string trim)

		# Replace the git_head variable with the original head.
		set git_rebase_head "$git_head"
		set git_head (cat < "$git_gitdir/rebase-merge/orig-head")

		# Try to find the original rebase branch.
		set -l __git_rebase_branch (string split '/' < "$git_gitdir/rebase-merge/head-name")
		if [ "$__git_rebase_branch[-1]" != "detached HEAD" ]
			set git_branch "$__git_rebase_branch[-1]"
		end
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
			set git_untracked true
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
