[⬅ Promptfessional](../README.md#documentation)

# Component: `private`

Displays a marker if the shell was started in private mode.

## Behavior

- When the shell is recording history, this component will be hidden.
- When the shell was started with `--private`, this component will display `⦸`.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--symbol`|`⦸`|Change the root user symbol.|

## Colors

|Name|Description|
|:--|:--|
|component.private|The color of the private indicator.|
