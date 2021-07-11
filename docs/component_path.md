[⬅ Promptfessional](../README.md#documentation)

# Component: `path`

Displays the path to the current directory.

## Behavior

- Displays the full path to the current directory.
- Renders decorations for any directories in the path.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--abbrev-parents`|`false`|Abbreviates (show the first letter only) parent directories.|
|`--collapse-home`|`false`|Collapses the path to `$HOME` into `~`.|
|`--decoration`||Adds a path [decoration](#decorations).|

## Colors

|Name|Description|
|:--|:--|
|component.path|The color of parent directories.|
|component.path.current|The color of the current directory.|
|component.path.current.ro|The color of the current directory, when the user doesn't have write permission.|

## Decorations

Decorations (also known as "path decorations") are special components that are applied to each directory in a path. Starting from the root directory, a decoration function is called for each directory up until and including the current directory. Any additional options given to the path component will be passed along to the decorations.

> **For example,** consider the path `/var/log/apache/` with a decoration called `my_decoration`. The following functions will be called:
> 
> - `my_decoration "/var" $argv`
> - `my_decoration "/var/log" $argv`
> - `my_decoration "/var/log/apache" $argv`


If the decoration function returns with a zero status code, its standard output will be printed after the directory in the path.

> **For example,** let's assume we have the following decoration:
> 
> ```fish
> function promptfessional_decoration_foo
>   if ! [ (basename -- "$argv[1]") = "foo" ]
>     return 1
>   end
>   
>   echo " (foo) "
>   return 0
> end
> ```
> 
> The path `/foo/bar/baz` will be printed as:
> 
> `/foo (foo) ` ` /bar` `/baz`


See [here](./custom_decoration.md) for information on creating custom decorations.
