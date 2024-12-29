-- lua/plugins/init.lua
local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- JavaScript/TypeScript tooling
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
        "js-debug-adapter",
        "cssls",
        "html-lsp",
        "tailwindcss-language-server",
        -- Rust tooling
        "rust-analyzer",
        "codelldb",
        "rustfmt",
        "taplo",
        -- C/C++ tooling
        "clangd",
        "clang-format",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local rt = require("rust-tools")
      rt.setup(require "configs.rust-tools")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      require "configs.dap"
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "saecki/crates.nvim",
    ft = {"toml"},
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      })
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "configs.null-ls"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults 
        "vim",
        "lua",
        -- web dev 
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        -- "vue", "svelte",  -- uncomment if needed
        -- Rust
        "rust",
        "toml",
      },
      autotag = {
        enable = true,
      },
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      indent = { enable = true },
    },
  },
  {
    "NvChad/nvterm",
    opts = {
      terminals = {
        type_opts = {
          float = {
            width = 0.8,
            height = 0.8,
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
      local options = require "configs.conform"
      return options
    end,
  },
  -- Optional but recommended for better development experience
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    config = function()
      require("trouble").setup()
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    },
  },
}

return plugins
