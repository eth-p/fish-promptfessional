[⬅ Promptfessional](../README.md#documentation)

# Custom Components

You can create custom components by defining a function with the name `promptfessional_component_[NAME]`. The component can be included in a section by using `promptfessional show [NAME]`.

## Arguments

`$argv` will be the arguments passed to the `promptfessional show` function.

It is highly recommended that you use [argparse](https://fishshell.com/docs/current/cmds/argparse.html) to parse options instead of relying on positional arguments.

## Rendering

> **Tip:** If the function returns a non-zero status code, the decoration will not be rendered.

The standard output stream will be used to render the component.


## Example

Show a sad face if the current directory contains a `.DS_Store` file:

```fish
function promptfessional_component_ds_store

  # If a .DS_Store file doesn't exist, return 1 to prevent the
  # component from being rendered.
  if ! [ -e './.DS_Store' ]
    return 1
  end
  
  # Print a sad face.
  printf ":("
  
end
```
