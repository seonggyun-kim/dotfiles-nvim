----------------------------------------------------------------
-- 0. Plugin Management
----------------------------------------------------------------
require("plugins")

----------------------------------------------------------------
-- 1. Core Settings
----------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.splitbelow = true      
opt.splitright = true      
opt.termguicolors = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.mouse = "a"
opt.clipboard = ""

-- Built-in completion settings for Phase 1
opt.completeopt = { "menuone", "noselect", "popup" }

----------------------------------------------------------------
-- 2. Workspace Management
----------------------------------------------------------------
require("workspace").auto_workspace()

----------------------------------------------------------------
-- 3. Phase 1: LSP Completion (Native Neovim 0.12)
----------------------------------------------------------------
require("lsp")

----------------------------------------------------------------
-- 3. Global Keymaps
----------------------------------------------------------------
local map = vim.keymap.set

----------------------------------------------------------------
-- Oil.nvim (The GOAT File Explorer)
-- Open parent directory in Oil
map("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open Oil (File Explorer)" })

----------------------------------------------------------------
-- Telescope - Your Fuzzy Command Center
----------------------------------------------------------------
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
map("n", "<leader>fc", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "LSP Symbols" })

-- ToggleTerm (same key to open/close)
map("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
map("t", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })

-- Workspace management
map("n", "<leader>ws", function() 
  require("workspace").auto_workspace() 
  vim.notify("Workspace set to: " .. vim.fn.getcwd())
end, { desc = "Set Workspace (auto-detect project root)" })
map("n", "<leader>wc", function()
  local path = vim.fn.input("Workspace path: ", vim.fn.getcwd())
  if path ~= "" then
    require("workspace").set_workspace(path)
  end
end, { desc = "Set Custom Workspace" })

----------------------------------------------------------------
-- Elite Navigation Between Windows
----------------------------------------------------------------
-- Ctrl+h/j/k/l to move between ANY windows (including terminal, file tree, etc.)
map({"n", "t"}, "<C-h>", "<C-w>h", { desc = "Move left" })
map({"n", "t"}, "<C-j>", "<C-w>j", { desc = "Move down" })
map({"n", "t"}, "<C-k>", "<C-w>k", { desc = "Move up" })
map({"n", "t"}, "<C-l>", "<C-w>l", { desc = "Move right" })

----------------------------------------------------------------
-- "Goated" Quality of Life Binds
----------------------------------------------------------------

-- Move visual blocks up/down with J and K (Automatic indentation!)
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in the middle when jumping half-pages
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Keep search terms in the middle
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- The "Greatest Gift": Paste over something without losing your current yank
-- This sends the deleted text to the black hole register (_)
map("x", "<leader>p", [["_dP"]])

-- Replace the word you are currently on globally
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>\>/gI<Left><Left><Left>]], { desc = "Global Search/Replace word under cursor" })

-- File management
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- File tree quick toggle
map("n", "<leader>o", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File Tree" })
map("n", "<leader>f", "<cmd>NvimTreeFocus<cr>", { desc = "Focus File Tree" })

-- System Clipboard (Space + y)
map({"n", "v"}, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Phase 1: Built-in LSP Completion
-- Ctrl+X Ctrl+O is automatically handled by Neovim 0.11+ with omnifunc

----------------------------------------------------------------
-- 4. Terminal Navigation (The Escape Hatch)
----------------------------------------------------------------
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  -- Jump between windows even while in terminal mode
  map('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
  map('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
  map('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
  map('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
  -- Allow Esc to exit terminal mode (optional, but standard)
  map('t', '<Esc>', [[<C-\><C-n>]], opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    set_terminal_keymaps()
  end,
})

----------------------------------------------------------------
-- 5. Load ft.lua
----------------------------------------------------------------
pcall(require, "ft")