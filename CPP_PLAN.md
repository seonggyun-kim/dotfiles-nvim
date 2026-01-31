# Elite Generic C++ Development Environment - Complete Implementation Plan

## Architecture Overview

### Plugin Structure (Most Elegant)
```
~/.config/nvim/
├── init.lua          # Loads modules
├── lua/
│   ├── plugins.lua   # vim.pack.add() + new plugins
│   ├── lsp.lua       # Existing LSP config (extend for clangd)
│   ├── workspace.lua # Existing workspace management
│   └── cpp.lua       # NEW: C++-specific development tools
```

## Required Plugins (Add to plugins.lua)

### Debug Ecosystem
- **nvim-dap** - Debug Adapter Protocol (core)
- **nvim-dap-ui** - Visual debugging interface
- **telescope-dap.nvim** - Debug commands in telescope
- **mfussenegger/nvim-dap-cpp** - C++ debugger adapter

### Build System Integration
- **folke/which-key.nvim** - Keybind documentation
- **nvim-telescope/telescope-live-grep-args.nvim** - Enhanced search

## cpp.lua Module Architecture

### 1. Core Detection System
```lua
-- Smart project detection with fallback chain
local M = {
  project_type = nil,
  compiler = "clang++",  -- User-configurable
  build_dir = "build"
}

-- Auto-detect project type on file open
function M.detect_project_type()
  if vim.fn.filereadable("CMakeLists.txt") == 1 then
    return "cmake"
  elseif vim.fn.filereadable("Makefile") == 1 then
    return "make"
  else
    return "single_file"
  end
end
```

### 2. Build System Integration (Most Robust)

**Priority Chain:** CMake → Make → Single File
- Auto-generates build directory for CMake
- Detects compile_commands.json for clangd
- Fallback to simple compilation
- Robust error handling at each level

**Build Functions:**
```lua
M.build_project()     -- Smart build based on detection
M.run_current()       -- Smart run (build + execute)
M.debug_current()      -- Smart debug launch
M.clean_project()      -- Clean build artifacts
```

### 3. Debug Integration (Most Goated)

**Hybrid Debug Approach:**
- **Immediate Debug:** `<leader>rd` launches debugger
- **Breakpoint-First:** Set breakpoints, then debug
- **Visual UI:** DAP-UI for intuitive debugging

**Debug Functions:**
```lua
M.toggle_breakpoint() -- Toggle at current line
M.debug_continue()    -- Continue execution
M.debug_step_over()  -- Step over line
M.debug_step_into()   -- Step into function
M.debug_step_out()    -- Step out of function
M.debug_restart()     -- Restart debug session
```

### 4. Code Quality Tools

**Format & Analysis:**
- clang-format integration with project detection
- clang-tidy for static analysis
- Automatic formatting on save (optional)
- Header/source file switching

## Keybind Strategy (Most Elegant)

### Context-Aware Keybinds
```lua
-- Build & Run (adapts to project type)
vim.keymap.set('n', '<leader>rr', M.run_current, { desc = 'Smart Run: Execute current file/project' })
vim.keymap.set('n', '<leader>rb', M.build_project, { desc = 'Smart Build: Compile/build based on project type' })
vim.keymap.set('n', '<leader>rc', M.clean_project, { desc = 'Clean Project: Remove build artifacts' })

-- Debug Controls (comprehensive workflow)
vim.keymap.set('n', '<leader>rd', M.debug_current, { desc = 'Debug: Start debugging current file/project' })
vim.keymap.set('n', '<leader>db', M.toggle_breakpoint, { desc = 'Breakpoint: Toggle at current line' })
vim.keymap.set('n', '<leader>dc', M.debug_continue, { desc = 'Debug: Continue execution' })
vim.keymap.set('n', '<leader>dn', M.debug_step_over, { desc = 'Debug: Step over current line' })
vim.keymap.set('n', '<leader>di', M.debug_step_into, { desc = 'Debug: Step into function' })
vim.keymap.set('n', '<leader>do', M.debug_step_out, { desc = 'Debug: Step out of current function' })

-- Code Quality (professional workflow)
vim.keymap.set('n', '<leader>cf', M.format_code, { desc = 'Format: Format current file with clang-format' })
vim.keymap.set('n', '<leader>ch', M.toggle_header_source, { desc = 'Toggle: Switch between .h/.cpp file' })
vim.keymap.set('n', '<leader>ct', M.run_with_input, { desc = 'Run with Input: Execute with custom input' })

-- Compiler Management (runtime control)
vim.keymap.set('n', '<leader>cc', M.switch_compiler, { desc = 'Switch Compiler: Toggle between clang++/g++' })
vim.keymap.set('n', '<leader>cs', M.show_compiler_info, { desc = 'Compiler Info: Show current compiler and flags' })
```

### Which-Key Integration
- Automatic keybind descriptions
- Visual guide for all C++ commands
- Context-aware display (only shows relevant keybinds for .cpp files)

## Error Handling Strategy

### Multi-Modal Error Display
1. **Floating Window** - Immediate compiler errors (elegant, non-intrusive)
2. **Quickfix List** - Compilation results (traditional vim workflow)
3. **Telescope Integration** - Navigate errors efficiently

### Error Sources
- Compiler output (clang++/g++)
- CMake errors
- Make errors
- Runtime errors (if applicable)

## Compiler Management System

### Smart Compiler Detection
```lua
-- Priority: clang++ > g++ > system default
function M.detect_best_compiler()
  if vim.fn.executable('clang++') == 1 then
    return 'clang++'
  elseif vim.fn.executable('g++') == 1 then
    return 'g++'
  else
    error('No C++ compiler found!')
  end
end
```

### Runtime Compiler Switching
- `<leader>cc` - Switch between compilers
- Persistent preference per project
- Automatic detection of compiler-specific flags

## Filetype Isolation (Non-Interfering)

### Autocommand Strategy
```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'cpp', 'c', 'hpp', 'h'},
  callback = M.setup_cpp_environment,
  desc = 'Setup C++ development environment'
})

function M.setup_cpp_environment()
  -- Only activate C++ keybinds for C++ files
  -- Only enable C++ LSP settings
  -- Only setup C++ build detection
end
```

## Implementation Steps

### Phase 1: Foundation
1. Add new plugins to `plugins.lua`
2. Create basic `cpp.lua` structure
3. Implement project detection system
4. Add basic compile/build keybinds

### Phase 2: Build System Integration
1. Implement CMake integration
2. Add Make support
3. Single file compilation fallback
4. Error handling and display

### Phase 3: Debug Integration
1. Setup nvim-dap for C++
2. Add DAP-UI integration
3. Telescope debug commands
4. Comprehensive debug keybinds

### Phase 4: Polish & Documentation
1. Which-key integration
2. Keybind documentation
3. Error message refinement
4. Performance optimization

## Testing Strategy

### Test Scenarios
1. Single file compilation (learncpp.com style)
2. CMake project with multiple files
3. Make project integration
4. Debug session workflow
5. Compiler switching
6. Error handling and display

### Validation Points
- No interference with other filetypes
- Robust fallback mechanisms
- Clear error messages
- Efficient performance
- Comprehensive keybind documentation

## Keybind Summary (For Your Reference)

### Build & Run
- `<leader>rr` - Smart Run (execute current file/project)
- `<leader>rb` - Smart Build (compile/build based on context)
- `<leader>rc` - Clean Project (remove build artifacts)

### Debug Controls
- `<leader>rd` - Debug (start debugging session)
- `<leader>db` - Breakpoint (toggle at current line)
- `<leader>dc` - Continue (resume execution)
- `<leader>dn` - Step Over (next line)
- `<leader>di` - Step Into (enter function)
- `<leader>do` - Step Out (exit current function)

### Code Quality
- `<leader>cf` - Format (clang-format current file)
- `<leader>ch` - Toggle Header/Source (switch .h ↔ .cpp)
- `<leader>ct` - Run with Input (execute with custom input)

### Compiler Management
- `<leader>cc` - Switch Compiler (clang++ ↔ g++)
- `<leader>cs` - Compiler Info (show current compiler & flags)

## Saved Plan Status
**Created:** January 31, 2026  
**Purpose:** Elite Generic C++ Development Environment for Neovim 0.12  
**Next Steps:** Ready for implementation when you return  

*This plan creates a truly elite, generic C++ development environment that scales from single files to complex projects while maintaining elegance and robustness.*