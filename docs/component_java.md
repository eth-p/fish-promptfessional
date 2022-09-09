[⬅ Promptfessional](../README.md#documentation)

# Component: `java`

Displays the Java version in the prompt.

## Behavior

- When `JAVA_HOME` is set, displays the major version of the selected JVM.
- When `--show-default`, displays the major version of the `java` command.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--pattern`|`java {version}`|The pattern to use.|
|`--show-default`|`false`|Still show if JAVA_HOME is unset.|

## Colors

|Name|Description|
|:--|:--|
|component.java|The color of the java component.|
|component.java.{version}|The color of the component for a specific Major version of the JVM.|

### Variables

When specifying a pattern string, you can provide the following template variables:

| Variable            | Description                                                  |
| :------------------ | :----------------------------------------------------------- |
| `{version}`         | The major version of the JVM.                                |
