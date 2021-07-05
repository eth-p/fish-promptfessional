[⬅ Promptfessional](../README.md#documentation)

# Component: `jobs`

Displays a marker and (optional) count of commands sent to the background with `&` or `^Z`.

## Behavior

- When there are no jobs, this component will be hidden.
- When there is one or more background job(s), this component will display `%`.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--with-count`|`false`|Show the number of background jobs.|
|`--symbol`|`%`|Change the jobs symbol.|

## Colors

|Name|Description|
|:--|:--|
|component.jobs|The color of the jobs indicator.|
|component.jobs.count|The color of the jobs count.|
