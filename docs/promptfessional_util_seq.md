[⬅ Promptfessional](../README.md#documentation)

# Command: `promptfessional util seq`

A faster (integer-only) version of the `seq` command.

This only uses builtin commands, which reduces the ~2ms overhead of forking and exec'ing an external process.

## Arguments

1. The starting index.
2. The ending index.

## Options

|Option|Type|Description|
|:--|:--|:--|
|`--step`|(integer)|The step size (default 1).|

## Usage

```fish
for i in (promptfessional util seq 1 10 --step=2
    echo $i
end
```
