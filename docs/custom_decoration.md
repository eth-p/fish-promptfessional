[⬅ Promptfessional](../README.md#documentation)

# Custom Decorations

You can create custom decorations by defining a function and passing its name to the [path component](./component_path.md)'s `--decoration` option.

## Arguments

`$argv[1]` will be the full path (not following symlinks) of the directory to decorate.

The remaining arguments will be the list of arguments initially passed to the `path` component. When you use argparse, make sure to use the `-i` flag.

## Rendering

> **Tip:** If the function returns a non-zero status code, the decoration will not be rendered. This can be used to exit early for paths that do not need decorating.

The standard output stream will be used to render the decoration.

When any decorations are added to a directory, the decorations will be padded with a space to both the left and right. If more than one decoration is added, they will be directly concatenated without a delimiter.

> **For example,**
> 
> No decorations: `/foo/bar/baz`  
> One decoration (`1`): `/foo/bar 1 /baz`  
> Two decorations (`1`, `2`): `/foo/bar 12 /baz`  


## Example

Show an asterisk if the directory contains a `.DS_Store` file:

```fish
function has_ds_store

  # If a .DS_Store file doesn't exist, return 1 to prevent the
  # decoration from being added to the directory.
  if ! [ -e "$argv[1]/.DS_Store" ]
    return 1
  end
  
  # Print an asterisk and return 0 to add the decoration.
  printf "*"
  
end
```
