local M = {}

local function build_and_run(mode)
  vim.cmd("w")

  local file = vim.fn.expand("%")
  local base = vim.fn.expand("%:r")

  local flags, out
  if mode == "debug" then
    flags = "-g -O0"
    out = base .. "_dbg"
  else
    flags = "-O2"
    out = base .. "_rel"
  end

  vim.cmd("!g++ -std=c++20 -Wall -Wextra " .. flags .. " " .. file .. " -o " .. out)
  vim.cmd("!./" .. out)
end

vim.keymap.set("n", "<leader>rd", function()
  build_and_run("debug")
end, { desc = "C++ debug build & run" })

vim.keymap.set("n", "<leader>rr", function()
  build_and_run("release")
end, { desc = "C++ release build & run" })

return M

