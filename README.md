# nvim_configs
neo vim configurations
this is configured with NV chad

![alt text](cap-forest.png)
![alt text](cap-cream.jpg)
![alt text](cap-black.png)
![alt text](cap-white.png)
![alt text](cap-rocky.png)

# NVChad Python Development Setup

## Configuration Files

### `lua/plugins/init.lua`
- Defines plugins to be installed by Lazy (plugin manager)
- Configures Mason's `ensure_installed` tools
- Sets up plugin dependencies and configurations
- Location for adding new plugins like Python debugger and Jupyter support

### `lua/configs/lspconfig.lua`
- Configures Language Server Protocols (LSPs)
- **Important**: Uses NVChad-specific paths (`require("nvchad.configs.lspconfig")`)
- Sets up Python LSPs (pyright and ruff_lsp)
- Inherits NVChad's default LSP configurations

## Setup Commands

Run these commands in order:

1. `:Lazy sync`
   - Downloads and installs all plugins defined in `init.lua`
   - Updates existing plugins
   - Must be run after modifying `init.lua`

2. `:MasonInstallAll`
   - Installs all tools specified in Mason's `ensure_installed`
   - Includes LSP servers, formatters, and debuggers
   - Must be run after Lazy sync completes

3. Install Python dependencies:
   ```bash
   pip install jupytext jupyter
   ```

## Verification Steps

1. Check LSP Status:
   ```
   :LspInfo
   ```
   Should show pyright and ruff_lsp as active for Python files

2. Test LSP Features:
   - `gd` - Go to definition
   - `K` - Hover documentation
   - `<leader>ca` - Code actions

3. Verify Debugger:
   - Set breakpoint: `<leader>db`
   - Start debugger: `<leader>dr`

## Common Issues

### Path-Related Problems

- Always use `require("nvchad.configs.lspconfig")` instead of `require("plugins.configs.lspconfig")`
- NVChad uses its own path structure for core configurations
- Watch for error messages about missing modules - they often indicate incorrect paths

### Plugin Loading Issues

- If plugins aren't working, check `:checkhealth`
- Ensure you ran `:Lazy sync` after modifying `init.lua`
- Verify Mason installed all tools with `:Mason` and check the list

### Python Environment

- Ensure Python and pip are installed system-wide
- debugpy requires a Python environment to be available
- Jupyter features need both jupytext and jupyter installed

## Troubleshooting

1. If LSP isn't working:
   - Check `:LspInfo` in a Python file
   - Verify Mason installed the servers
   - Look for path-related errors in `:checkhealth`

2. If plugins aren't loading:
   - Run `:Lazy sync` again
   - Check `:Lazy` for plugin status
   - Verify plugin paths in `init.lua`
