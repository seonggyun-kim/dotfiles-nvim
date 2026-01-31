vim.pack.add({
  -- Theme
  { src = "shaunsingh/nord.nvim" },

  -- File editing & navigation
  { src = "stevearc/oil.nvim" },
  { src = "nvim-tree/nvim-tree.lua" },
  { src = "akinsho/toggleterm.nvim" },

  -- Fuzzy finder
  { src = "nvim-lua/plenary.nvim" },
  { src = "nvim-telescope/telescope.nvim" },

  -- Syntax
  { 
    src = "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- LSP
  { src = "neovim/nvim-lspconfig" },

  -- LaTeX
  { src = "lervag/vimtex" },
})

-- Plugin configurations
vim.g.nord_contrast = false
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = false

-- Apply theme
require('nord').set()
vim.cmd.colorscheme("nord")

-- Configure plugins
require("oil").setup({})
require("nvim-tree").setup({
  view = { width = 30 },
  renderer = { 
    icons = { show = { git = false, diagnostics = false } }
  },
  filters = {
    dotfiles = false,  -- Show hidden files by default
    custom = { ".git", "node_modules", ".cache" }  -- Still hide these specific ones
  }
})
require("telescope").setup({
  defaults = { sorting_strategy = "ascending", layout_config = { prompt_position = "top" } },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
    }
  }
})
require("nvim-treesitter").setup({
  ensure_installed = { "cpp", "c", "lua", "python", "bash", "latex" },
  highlight = { enable = true }, indent = { enable = true }
})
require("toggleterm").setup({
  size = 20,
  open_mapping = [[<c-\>]],
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  persist_size = true,
  direction = "horizontal",
})

