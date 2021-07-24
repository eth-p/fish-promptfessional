[⬅ Promptfessional](../README.md#documentation)

# Command: `promptfessional util ansi_extract`

Extracts ANSI colors from a string.

## Arguments

1. The string to extract colors from.

## Options

|Option|Type|Description|
|:--|:--|:--|
|`--first`|(flag)|Extract the first color seen.|
|`--last`|(flag)|Extract the last color seen.|
|`--foreground`|(flag)|Extract the foreground color.|
|`--background`|(flag)|Extract the background color.|
|`--sequences`|(flag)|Extract a block of consecutive ANSI escape sequences.|
|`--unrendered`|(flag)|Prints the color code instead of the escape sequence.|

## Usage

```console
$ set my_text (printf "%s%s%s" (set_color red) "hi" (set_color green))
$ promptfessional util ansi_extract "$my_text" --last --foreground --unrendered
32 # the color for green
```

## Limitations

- Only supports foreground and background codes.
- Does not support the reverse attribute.
