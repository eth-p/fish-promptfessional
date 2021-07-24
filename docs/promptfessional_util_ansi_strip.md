[⬅ Promptfessional](../README.md#documentation)

# Command: `promptfessional util ansi_strip`

Strips ANSI escape sequences from a string.

This currently only supports color codes.


## Arguments

1. The string to strip.

## Options

None.

## Usage

```console
$ printf "%snot red" (promptfessional util ansi_strip (set_color red))
not red
```
