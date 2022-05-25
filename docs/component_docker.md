[⬅ Promptfessional](../README.md#documentation)

# Component: `docker`

Displays the current `DOCKER_CONTEXT`.

## Behavior

- Displays the value of the `DOCKER_CONTEXT` variable.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--symbol`|(None)|Display a symbol before the context.|
|`--hide-context=[name]`|(None)|Hide the context with the specified name.<br />Can be specified multiple times.|
|`--hide-default`|False|Hide when no context is specified.|
|`--show-unexpected`|False|Show the context even when `DOCKER_CONTEXT` is not exported.|

## Colors

|Name|Description|
|:--|:--|
|component.docker|The color of the docker indicator.|
