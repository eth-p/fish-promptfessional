[⬅ Promptfessional](../README.md#documentation)

# Command: `promptfessional enable`

Enables a prompt feature.

This must be run first in the `fish_prompt` command.


## Features

- `arrow` - Adds Powerline arrows between prompt sections.
- `timing` - Prints execution time for each rendered component.
  

## Usage

```fish
function fish_prompt
  promptfessional enable [feature]
  
  promptfessional section ...
    prompfessional component ...
end
```
