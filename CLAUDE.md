# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a modern Neovim configuration built around **lazy.nvim** plugin manager with a clean, modular structure. Configuration is split between core modules in `lua/jmitsch/` and plugin-specific configurations in `after/plugin/`.

### Configuration Flow
1. `init.lua` → `require("jmitsch")` (entry point)
2. `lua/jmitsch/init.lua` loads modules in order:
   - `remap.lua` (custom keymaps)
   - `lazy.lua` (plugin definitions)  
   - `set.lua` (vim options)
   - `auto.lua` (autocommands)
3. `after/plugin/` files load after plugins are installed

## Key Components

### Plugin Management
- **Manager**: lazy.nvim
- **Lock file**: `lazy-lock.json` tracks exact versions
- **Adding plugins**: Add to `lua/jmitsch/lazy.lua` + create `after/plugin/[name].lua`
- **Updates**: Use `:Lazy` command

### LSP Configuration (`after/plugin/lsp.lua`)
- **Manager**: Mason.nvim for server installation
- **Supported languages**: Lua, Go, Python, Ruby, C/C++, Helm, TypeScript, Rust
- **Special handling**: Rust uses rustaceanvim, TypeScript uses typescript-tools
- **Formatting**: Conform.nvim with format-on-save
- **Completion**: nvim-cmp with LSP source

### File Navigation
- **Fuzzy finder**: telescope.nvim with find_pickers extension
- **File explorer**: oil.nvim (access with `-` key)
- **Leader key**: Space (`<leader>`)

### UI/Theme
- **Colorscheme**: Tokyo Night (night variant) with transparency
- **Status line**: Custom lualine with mode, file status, git, LSP, diagnostics
- **Terminal**: FTerm.nvim with fish shell

## Development Patterns

### Adding New Language Support
1. Add LSP server to Mason configuration in `after/plugin/lsp.lua`
2. Configure server settings in the `servers` table
3. Add formatter to `after/plugin/lsp.lua` conform setup if needed
4. Create language-specific snippets in `snippets/` if needed

### Customizing Keymaps
- **Core keymaps**: `lua/jmitsch/remap.lua`
- **LSP keymaps**: `after/plugin/lsp.lua` (telescope-integrated)
- **Plugin-specific**: Each plugin's `after/plugin/` file

### Plugin Configuration Pattern
1. Define plugin in `lua/jmitsch/lazy.lua`
2. Create `after/plugin/[plugin-name].lua` for configuration
3. Use lazy loading specs for performance
4. Plugin configs load automatically after plugin installation

## Language-Specific Features

### Ruby
- Uses ruby_lsp with rbenv PATH configuration
- Special bundle exec integration for project-specific gems

### Rust  
- rustaceanvim handles LSP, DAP, and rust-analyzer integration
- Separate from Mason-managed servers

### TypeScript
- typescript-tools.nvim for enhanced TS/JS support  
- Custom snippets in `snippets/typescript.snippets`

### JSON
- Custom autocommands for formatting in `lua/jmitsch/auto.lua`

## Common Tasks

### Plugin Management
- `:Lazy` - Open plugin manager
- `:Lazy update` - Update plugins
- `:Lazy sync` - Sync plugins with lazy-lock.json

### LSP Operations
- `<leader>f` - Format current buffer
- `gd` - Go to definition (via telescope)
- `gr` - Go to references (via telescope)
- `K` - Hover documentation
- `<leader>ca` - Code actions

### File Navigation
- `<leader>pf` - Find files (telescope)
- `<leader>ps` - Live grep search
- `<leader>pg` - Git files
- `-` - Open parent directory (oil.nvim)