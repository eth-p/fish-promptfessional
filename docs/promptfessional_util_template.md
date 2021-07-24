[⬅ Promptfessional](../README.md#documentation)

# Command: `promptfessional util template`

Replace template variables in a string.

Template variables are alphanumeric strings enclosed in `{}`. They may also contain non-alphanumeric prefixes and suffixes, which will be stripped if the variable's replacement value is empty.

## Arguments

1. The template string.
2. Variable name.
3. Variable value.
4. (Repeat variable name and variable value)

## Options

None

## Usage

Replace a single variable:

```console
$ promptfessional util template -- "hello {target}" target world
hello world
```

Replace multiple variables:

```console
$ promptfessional util template -- "hello {target}, I'm {source}" \
$   target world \
$   source "a template" 
hello world, I'm a template
```

Variable prefix and suffixes:

```console
$ promptfessional util template -- "{author: }hi" author ''
hi

$ promptfessional util template -- "{author: }hi" author 'john'
john: hi
```
