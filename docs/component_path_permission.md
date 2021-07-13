[⬅ Promptfessional](../README.md#documentation)

# Component: `path_permission`

Displays the user's permissions in the current directory.

## Behavior

- When the user has no read permission, this component will display `[na]`.
- When the user has no write permission, this component will display `[ro]`.
- When the user has read and write permission and `--always` is true, this component will display `[rw]`.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--always`|`false`|Always show the component, even if the user has full read-write.|
|`--symbol-default`|`[rw]`|Text to show when the current directory is read-write.|
|`--symbol-no-read`|`[na]`|Text to show when the user cannot read the current directory.|
|`--symbol-no-write`|`[ro]`|Text to show when the user cannot write to the current directory.|

## Colors

|Name|Description|
|:--|:--|
|component.path_permission|The color when the user has read-write permission.|
|component.path_permission.no_read|The color when the user has no read permission.|
|component.path_permission.no_write|The color when the user has no write permission.|
