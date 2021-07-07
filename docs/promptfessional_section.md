[⬅ Promptfessional](../README.md#documentation)

# Command: `promptfessional section`

Declares the start of a prompt section.




## Restrictions

- This must eventually be followed by either `promptfessional section`, or `promptfessional end`.  
  Failure to do so will result in the section not being displayed.
  

## Usage

`promptfessional section (OPTIONS) [SECTION_NAME]`

Create a section:

```fish
promptfessional section my_section
    promptfessional show my_component
    promptfessional show my_other_component
promptfessional end
```

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--pattern`|` %s `|Set the printf pattern for the section.<br>This can be used to override the left and right padding.|
|`--delimiter`|``|Set the delimiter between each component in the section.|

## Colors

Sections can be individually colored with the color `section.[SECTION_NAME]`.

> **For example,** for a section called `foo`, its color will be `section.foo`.
> ```fish
> promptfessional color --set section.foo --background=red
> ```

## Special Considerations

- If the `--pattern` ends with a space and the last component ends with a space, only one trailing space will be printed.
