[⬅ Promptfessional](../README.md#documentation)

# Component: `sudo`

Displays a marker if the shell is running as the root user.

## Behavior

- When the user is not root, this component will be hidden.
- When the user is root, this component will display `$`.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--uid`|`0`|The uid of the root user.|
|`--symbol`|`$`|Change the root user symbol.|

## Colors

|Name|Description|
|:--|:--|
|component.sudo|The color of the sudo indicator.|
