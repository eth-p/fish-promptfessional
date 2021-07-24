
### Build your own prompt

Don't like the default prompt? That's ok, you can customize it however you like. Let's take a look at the default to see how to customize a prompt:

```fish
function fish_prompt
    promptfessional section status --delimiter=' '
        promptfessional show status
        promptfessional show private
        promptfessional show jobs
        promptfessional show sudo

    promptfessional section path --pattern=' %s '
        promptfessional show path \
        	--collapse-home \
        	--abbrev-parents \
        	--decoration promptfessional_decoration_git \
        	--git-hide-branch main \
        	--git-hide-branch master 

    promptfessional end
    promptfessional literal " "
end
```

When you call `promptfessional section [name]`, you're creating a new prompt section. Subsequent calls to `promptfessional show [component]` will add a component to your section.

For the "status" section above, you can see that it's made up of three components:
- `status`, which shows the exit code of the last command.
- `private`, which shows you when the shell was started with `--private`.
- `jobs`, which shows you if any background jobs are running.
- `sudo`, which shows you if you're running a root shell.

When any of these components are visible, they will be displayed in order of first appearance.

You might also notice that the section also has an option, `--delimiter=' '`. This tells Promptfessional to put a space between each displayed component within this section.

Next, let's look at the "path" section. This section only has the `path` component, but that component has a bunch of different options. You can find out about most of them [in the reference section](#reference), but here's a quick mention for the `--decoration` option:

Decorations are special components that are applied to individual directories in the path. These display contextual info about their respective directories (e.g. git status).

### Build your own component

See [custom_component.md](custom_component.md) for custom components.

See [custom_decoration.md](custom_decoration.md) for custom path decorations.



## Reference

### Core

- [promptfessional color](promptfessional_color.md)
- [promptfessional enable](promptfessional_enable.md)
- [promptfessional section](promptfessional_section.md)
- [promptfessional util ansi_strip](promptfessional_util_ansi_strip.md)
- [promptfessional util seq](promptfessional_util_seq.md)

### Components

- [status](component_status.md)
- [sudo](component_sudo.md)
- [jobs](component_jobs.md)
- [path](component_path.md)
- [path_permission](component_path_permission.md)
- [private](component_private.md)

### Path Decorations

- [git](decoration_git.md)
