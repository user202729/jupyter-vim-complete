# jupyter-vim-complete

Autocomplete for jupyter-vim plugin, uses the running kernel instead of Jedi-vim's approach of parsing the file.

### Why?

There are a few cases like this

```
import sys
exec("a=sys")
a.
```

where neither Jedi-vim nor vim's default autocompleter can handle properly.

More practically, there might be some commands that is only executed on the kernel, and not in the vim buffer.

(in general, because Python is very dynamic, it's impossible to autocomplete correctly without executing the code)

Besides, this approach is faster than Jedi-vim.

### Installation

This plugin requires the jupyter-vim plugin.

Add the line `source <full path to jupyter-vim-complete folder>/jupyter-vim-complete.vim` to `<vim configuration folder>/after/ftplugin/python.vim`.

To check if the plugin is successfully loaded: run `:set omnifunc?` in vim while a Python program is opened. Output should be `omnifunc=CompleteJupyter`.

To use the plugin: in a Python file, after having connected with `:JupyterConnect`, press `<c-x><c-o>`.

### Internal implementation

The plugin passes *one* line (the current line) to the kernel to complete.
Therefore if the context is dependent on the previous line, it may not work.

