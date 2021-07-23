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
3. Untracked files? => `git.untracked`
4. No untracked files, staged changes, or unstaged changes? => `git.clean`

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--git-hide-branch`||Hides the branch name if it's equal to this option.|
|`--git-long-hash`||Uses full commit hashes instead of short hashes. (Not recommended!)|
|`--git-pattern-branch`|` {symbol}{branch}{status} `|The default pattern to use for the git decoration.|
|`--git-pattern-detached`|` {symbol}{head}{status} `|The pattern to use when git has a detached HEAD.|
|`--git-pattern-merge`|` {symbol}{branch_or_head }merge({merge_head}){status} `|The pattern to use when git is merging.|
|`--git-pattern-rebase`|` {symbol}rebase({head}){status} `|The pattern to use when git is rebasing.|
|`--git-symbol-branch`|`⎇ `|Changes the symbol used to represent a branch.|
|`--git-symbol-head`|`➦`|Changes the symbol used to represent a detached head.|
|`--git-symbol-staged`|`~`|Changes the symbol used to represent staged changes.|
|`--git-symbol-unstaged`|`*`|Changes the symbol used to represent unstaged changes.|
|`--git-use-cache`|false|Enables experimental caching support for a faster prompt.|

## Colors

|Name|Description|
|:--|:--|
|git.clean|Used when the worktree is clean.|
|git.staged|Used when there are staged but uncommitted changes.|
|git.unstaged|Used when there are modified but unstaged changes.|
|git.untracked|Used when there are untracked files.|

## Caching

Fetching the status of a large git repository can take quite a bit of time, unfortunately. Promptfessional has *experimental* support (via the `--git-use-cache` option) for caching the git status to speed up the prompt.

This functionality relies on the filesystem recursively updating the modification date of parent directories whenever a file or directory is modified. If your filesystem does not support this, **do not enable this option**.

## Customizable Patterns

The git decoration can be configured to use user-specified patterns when git is performing an operation or is in a certain state (e.g. detached HEAD).

The list of customizable patterns can be found under the decoration [options](#options).

### Variables

When specifying a pattern string, you can provide the following template variables:

|Variable|Description|
|:--|:--|
|`{branch}`|The branch name. Empty if in a detached HEAD.|
|`{branch }`|Same as `{branch}`, but with a space at the end if not empty.|
|`{branch:}`|Same as `{branch}`, but with a colon at the end if not empty.|
|`{branch_or_head}`|The branch name, or the commit hash of the HEAD if detached.|
|`{branch_or_head }`|Same as `{branch_or_head}`, but with a space at the end if not empty.|
|`{branch_or_head:}`|Same as `{branch_or_head}`, but with a colon at the end if not empty.|
|`{color:}`|The decoration color.|
|`{head}`|The commit hash of the HEAD.|
|`{merge_head}`|The hash of the commit being merged.|
|`{status}`|The status symbols showing if there are staged or unstaged changes.|
|`{symbol}`|The head or branch symbol, depending on whether the HEAD is detached.|
