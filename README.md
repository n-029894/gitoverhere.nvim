# GitOverHere.nvim

GitOverHere is a Neovim plugin that allows you to quickly open the current file or selected lines in your default web browser, or copy the GitHub URL to your clipboard. It's particularly useful for sharing code snippets or quickly navigating to the web version of your repository.

## Features

- Open current file in browser at the GitHub repository
- Copy GitHub URL to clipboard instead of opening
- Support for line ranges and single line selections
- Works with both default branch and current branch
- Handles markdown files with plain text view
- Supports visual mode selections

## Installation

### Using [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'your-username/gitoverhere.nvim'
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'your-username/gitoverhere.nvim'
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    'your-username/gitoverhere.nvim',
    config = function()
        require('gitoverhere').setup()
    end
}
```

## Usage

The plugin provides a single command `:GitOverHere` that can be used in multiple ways:

### Basic Commands

- `:GitOverHere` - Opens the current file in browser (default branch)
- `:GitOverHere branch` - Opens the current file in browser (current branch)
- `:GitOverHere copy` - Copies the current file's URL to clipboard (default branch)
- `:GitOverHere copy branch` - Copies the current file's URL to clipboard (current branch)

### Visual Mode

1. Select lines in visual mode
2. Run `:GitOverHere` with desired options
3. The URL will include line numbers for the selected range

### Examples

```vim
" Open file in browser (default branch)
:GitOverHere

" Open file in browser (current branch)
:GitOverHere branch

" Copy URL to clipboard (default branch)
:GitOverHere copy

" Copy URL to clipboard (current branch)
:GitOverHere copy branch

" Open selected lines in browser (default branch)
:'<,'>GitOverHere

" Copy URL with line selection to clipboard (current branch)
:'<,'>GitOverHere copy branch
```

## Configuration

The plugin requires no configuration and works out of the box. Simply call the setup function in your `init.lua`:

## Example Keymaps

```lua
-- Default branch keymaps
vim.keymap.set('n', '<leader>mo', ':GitOverHere<cr>', { desc = "Open file in browser (default branch)" })
vim.keymap.set('v', '<leader>mo', ':GitOverHere<cr>', { desc = "Open file in browser with line selection (default branch)" })
vim.keymap.set('n', '<leader>mc', ':GitOverHere copy<cr>', { desc = "Copy URL to clipboard (default branch)" })
vim.keymap.set('v', '<leader>mc', ':GitOverHere copy<cr>', { desc = "Copy URL with line selection to clipboard (default branch)" })

-- Current branch keymaps
vim.keymap.set('n', '<leader>bo', ':GitOverHere branch<cr>', { desc = "Open file in browser (current branch)" })
vim.keymap.set('v', '<leader>bo', ':GitOverHere branch<cr>', { desc = "Open file in browser with line selection (current branch)" })
vim.keymap.set('n', '<leader>bc', ':GitOverHere copy branch<cr>', { desc = "Copy URL to clipboard (current branch)" })
vim.keymap.set('v', '<leader>bc', ':GitOverHere copy branch<cr>', { desc = "Copy URL with line selection to clipboard (current branch)" })
```

## Requirements

**Note: Only macOS is supported at the moment.**

- Neovim
- Git repository with a remote origin
- macOS (uses `pbcopy` for clipboard and `open` for browser)
- Internet connection for opening GitHub URLs

The plugin uses several system commands:
- `git` - for repository information
- `awk` - for text processing
- `sed` - for text processing
- `echo` - for string operations
- `pbcopy` - for copying to clipboard (macOS)
- `open` - for opening URLs in browser (macOS)
