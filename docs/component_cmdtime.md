[⬅ Promptfessional](../README.md#documentation)

# Component: `cmdtime`

Displays how long it took to execute the previous command.

## Behavior

- When the last command was successful, this component will be hidden.
- When the last command was unsuccessful, this component will display `!`.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--min-slow`|`10000`|Commands that take longer than this are considered slow.|
|`--min-time`|`0`|Commands that take less time than this don't have their time displayed.|
|`--pattern`|`{color}{time}{unit_color}{unit}`|The pattern to use.|
|`--precision`|`2`|Decimal number precision.|

## Colors

|Name|Description|
|:--|:--|
|component.cmdtime|The color of the time number.|
|component.cmdtime.slow|The color of the time number for slow commands.|
|component.cmdtime.unit|The color of the time unit.|

## Variables

When specifying a pattern string, you can provide the following template variables:

|Variable|Description|
|:--|:--|
|`{color}`|The time color.|
|`{time}`|The command time.|
|`{time_integer}`|The command time (whole number).|
|`{time_decimal}`|The command time (decimal).|
|`{time_ms}`|The command time in milliseconds.|
|`{unit}`|The time unit.|
|`{unit_color}`|The unit color.|
