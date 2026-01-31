-- 1. Handle the "on_attach" logic globally via Autocommands
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Enable built-in native completion (Neovim 0.12+)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        convert = function(item)
          -- Simple regex to strip parentheses from labels
          return { abbr = item.label:gsub("%b()", "") }
        end,
      })
    end

    -- Add your keymaps here (e.g., vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr }))
  end,
})

-- 2. Enable servers using the new native configuration
-- Note: As of Neovim 0.11, many servers are becoming built-in.
-- If 'vim.lsp.enable' isn't available in your specific build yet, 
-- you can still use this structure with lspconfig.

local servers = {
  clangd = {},
  pyright = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } }
      }
    }
  },
}

-- Batch enable the servers using native Neovim 0.12 approach
for server, config in pairs(servers) do
  vim.lsp.enable(server, config)
end

print("LSP servers configured natively")
