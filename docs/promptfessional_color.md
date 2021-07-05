[⬅ Promptfessional](../README.md#documentation)

# Command: `promptfessional color`

Gets or sets a prompt color.

Prompt colors are named presets for [set_color](https://fishshell.com/docs/current/cmds/set_color.html) values. For the purpose of this documentation, "color" refers to the prompt color name and "color code" refers to the color's value. 


## Restrictions

- Colors **must** match the following regular expression:  
  `^[a-z.]+$`
  

## Usage

`promptfessional color (--set) [COLOR] (COLOR_CODE|--or=[COLOR])`

Get a color:

```fish
set -l my_color (promptfessional color my.color)
```

Get a color, with another color as a fallback:

```fish
set -l path_color (promptfessional color component.path.current --or=component.path)
```

Set the color code for a color:

```fish
promptfessional color --set my.color red                      # FG=red, BG=inherit
promptfessional color --set my.color red --background=green   # FG=red, BG=green
```

## Options

|Option|Type|Description|
|:--|:--|:--|
|`--set`|(flag)|Sets the specified color.|
|`--or`|(color)|Output this color if the specified color is not defined.|
