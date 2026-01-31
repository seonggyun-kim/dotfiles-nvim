-- Workspace management
local M = {}

-- Set workspace root (like VSCode "Open Folder")
M.set_workspace = function(path)
  vim.cmd("cd " .. path)
  print("Workspace: " .. path)
end

-- Auto-detect project root (looks for .git, package.json, Cargo.toml, etc.)
M.find_project_root = function()
  local markers = {".git", "package.json", "Cargo.toml", "pyproject.toml", "CMakeLists.txt"}
  local current_dir = vim.fn.expand("%:p:h")
  
  while current_dir ~= "/" do
    for _, marker in ipairs(markers) do
      if vim.fn.filereadable(current_dir .. "/" .. marker) == 1 or 
         vim.fn.isdirectory(current_dir .. "/" .. marker) == 1 then
        return current_dir
      end
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end
  return vim.fn.getcwd()
end

-- Auto-set workspace to project root when opening a file
M.auto_workspace = function()
  local root = M.find_project_root()
  M.set_workspace(root)
end

return M