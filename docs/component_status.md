[⬅ Promptfessional](../README.md#documentation)

# Component: `status`

Displays the `$status` of the previously executed command.

## Behavior

- When the last command was successful, this component will be hidden.
- When the last command was unsuccessful, this component will display `!`.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--always`|`false`|Always show the component, even if the last command was successful.|
|`--symbol`|`!`|Change the command error symbol.|
|`--with-code`|`false`|Show the exit code instead of just "!" or " "|

## Colors

|Name|Description|
|:--|:--|
|component.status.ok|Used when the last command was successful.|
|component.status.error|Used when the last command was unsuccessful.|
