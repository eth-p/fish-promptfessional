[⬅ Promptfessional](../README.md#documentation)

# Command: `_promptfessional_var_cache`

Cache local variables, preventing unnecessary command invocations.

This requires a cache namespace (used to uniquely identify your variables), and a cache key (used to check if the cache is outdated).

>  **Warning:**  
>  This uses `eval` and does not sanitize some of the arguments.  
>  Do not allow an untrusted user to provide variable names or the cache namespace.

## Usage

Example:

```fish
function my_function
    set -l git_status
    
    if not _promptfessional_var_cache \
        --cache-namespace="my_function" \
        --cache-key=(pwd) \
        git_status
        
        set git_status (git status)
        _promptfessional_var_cache --update-cache \
            --cache-namespace="my_function" \
            --cache-key=(pwd) \
            git_status
    end
    
    echo $git_status
end
```


