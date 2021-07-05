[⬅ Promptfessional](../README.md#documentation)

# Decoration: `git`

A path deocration which displays the status of a git repository.

## Applies to

- Directories containing a `.git` folder. 

## Behavior

- Displays the branch symbol followed by the branch name.
- When there are staged changes, prints "~".
- When there are unstaged changes, prints "*".

The color is chosen in this priority: 

1. Unstaged changes (excluding untracked files)? => `git.unstaged`
2. Staged changes? => `git.staged`
3. Untracked files? => `git.dirty`
4. No untracked files, staged changes, or unstaged changes? => `git.clean`

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--git-hide-branch`||Hides the branch name if it's equal to this option.|
|`--git-symbol-branch`|`⎇ `|Changes the symbol used to represent a branch.|
|`--git-symbol-staged`|`~`|Changes the symbol used to represent staged changes.|
|`--git-symbol-unstaged`|`*`|Changes the symbol used to represent unstaged changes.|

## Colors

|Name|Description|
|:--|:--|
|git.clean|Used when the worktree is clean.|
|git.dirty|Used when there are untracked files.|
|git.staged|Used when there are staged but uncommitted changes.|
|git.unstaged|Used when there are modified but unstaged changes.|
