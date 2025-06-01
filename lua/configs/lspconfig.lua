-- load defaults from NvCad
require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Base servers with default config
local servers = { "html", "cssls", "eslint", "tailwindcss", "emmet_ls", "jsonls", "stylelint_lsp" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Gleam setup with specific configuration
lspconfig.gleam.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    gleam = {
      checkOnSave = true,
      includeTests = true,
    }
  }
}

-- Clangd setup
lspconfig.clangd.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    fallbackFlags = { "-I/usr/include/linux" },
  },
}

-- TypeScript setup with typescript-language-server
lspconfig.ts_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    preferences = {
      disableSuggestions = false,
    },
    hostInfo = "neovim",
    maxTsServerMemory = 4096,
    tsserver = {
      logVerbosity = "verbose",
    },
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        completeFunctionCalls = true,
        includeCompletionsForImportStatements = true,
        autoImports = true,
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        completeFunctionCalls = true,
        includeCompletionsForImportStatements = true,
        autoImports = true,
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
    },
  },
}

-- Python setup
lspconfig.pyright.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
      },
      venvPath = "", -- Will be auto-detected
    },
  },
  before_init = function(_, config)
    -- Function to find Poetry environment
    local function find_poetry_venv()
      local cwd = vim.fn.getcwd()
      local pyproject_path = cwd .. "/pyproject.toml"
      
      -- Check if pyproject.toml exists
      if vim.fn.filereadable(pyproject_path) == 1 then
        local handle = io.popen("cd " .. cwd .. " && poetry env info --path 2>/dev/null")
        if handle then
          local poetry_path = handle:read("*a"):gsub("%s+", "")
          handle:close()
          if poetry_path and poetry_path ~= "" and vim.fn.isdirectory(poetry_path) == 1 then
            return poetry_path .. "/bin/python"
          end
        end
      end
      return nil
    end
    
    -- Function to find conda environment
    local function find_conda_venv()
      local conda_env = vim.fn.getenv "CONDA_DEFAULT_ENV"
      if conda_env and conda_env ~= vim.NIL then
        local conda_prefix = vim.fn.getenv "CONDA_PREFIX"
        if conda_prefix and conda_prefix ~= vim.NIL then
          return conda_prefix .. "/bin/python"
        end
      end
      return nil
    end
    
    -- Detect Python environment in order of preference: Poetry -> VIRTUAL_ENV -> Conda -> System
    local python_path = find_poetry_venv()
    
    if not python_path then
      local venv = vim.fn.getenv "VIRTUAL_ENV"
      if venv and venv ~= vim.NIL then
        python_path = venv .. "/bin/python"
      end
    end
    
    if not python_path then
      python_path = find_conda_venv()
    end
    
    if not python_path then
      python_path = vim.fn.exepath "python3" or vim.fn.exepath "python"
    end
    
    config.settings.python.pythonPath = python_path
    
    -- Set additional search paths for Poetry projects
    local cwd = vim.fn.getcwd()
    if vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
      config.settings.python.analysis = config.settings.python.analysis or {}
      config.settings.python.analysis.extraPaths = config.settings.python.analysis.extraPaths or {}
      table.insert(config.settings.python.analysis.extraPaths, cwd)
    end
  end,
}

-- Ruff setup (replacing ruff_lsp)
lspconfig.ruff.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    ruff = {
      lint = {
        -- Ruff linter settings
        run = "onType", -- or "onSave"
      },
    },
  },
}
