# Stylent

Stylent is a simple neovim plugin which allow you to highlight
certain patterns in comment

version: prototype

```lua
require("stylent").setup()
```

```lua
require("stylent").setup({
    patterns = {
        {"%*%*.-%*%*", "StylentBold"} -- use lua pattern matching syntax
    }
})
```

Pattern is (pattern string, highlight group)

This is my first plugin lol

Todo:
- Improve code 
- Ensure reliability
- Write proper readme
