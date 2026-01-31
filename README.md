# Neovim 0.12 Configuration

Elite, elegant Neovim setup using native package management.

## Features

- **Native Package Manager**: Uses `vim.pack.add()` (Neovim 0.12+)
- **Modern LSP**: Native LSP completion with `vim.lsp.enable()`
- **Goated File Management**: Oil.nvim + Nvim-tree
- **Fuzzy Finding**: Telescope with elite keybinds
- **Workspace Management**: VSCode-like project detection
- **Theme**: Nord with optimized settings

## Keybinds

### File Management
- `<leader>e` - Oil file explorer
- `<leader>o` - Toggle nvim-tree
- `<leader>f` - Focus file tree

### Telescope (Fuzzy Command Center)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags
- `<leader>fc` - Git commits
- `<leader>fs` - LSP symbols

### Workspace
- `<leader>ws` - Auto-detect project root
- `<leader>wc` - Set custom workspace

### Navigation
- `<C-h/j/k/l>` - Move between windows
- `<leader>t` - Toggle terminal

## Setup

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles-nvim.git ~/.config/nvim
```

Plugins auto-install on first launch via native package manager.