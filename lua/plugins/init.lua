-- lua/plugins/init.lua
local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python tooling
        "pyright",
        "ruff",
        "black",
        "isort",      -- Added for Python import sorting
        "debugpy",
        "mypy",       -- Added for enhanced type checking
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
        -- Gleam tooling
        "gleam",
        -- Debug adapters
        "js-debug-adapter",
        "node-debug2-adapter",
        "python-debug-adapter",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  -- Themes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      require("nightfox").setup {
        options = {
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          },
        },
      }
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000,
  },
  {
    "sainnhe/everforest",
    priority = 1000,
  },
  {
    "sainnhe/edge",
    priority = 1000,
  },
  {
    "arcticicestudio/nord-vim",
    priority = 1000,
  },
  -- Additional aesthetic themes
  {
    "folke/lsp-colors.nvim",
    priority = 1000,
  },
  {
    "cocopon/iceberg.vim",
    priority = 1000,
  },
  {
    "dracula/vim",
    name = "dracula",
    priority = 1000,
  },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    priority = 1000,
  },
  {
    "marko-cerovac/material.nvim",
    priority = 1000,
  },
  {
    "embark-theme/vim",
    name = "embark",
    priority = 1000,
  },
  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    priority = 1000,
  },
  {
    "folke/twilight.nvim",
    priority = 1000,
  },
  {
    "mcchrish/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    priority = 1000,
  },
  {
    "savq/melange-nvim",
    priority = 1000,
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
  },
  {
    "romgrk/doom-one.vim",
    priority = 1000,
  },
  {
    "Shatur/neovim-ayu",
    priority = 1000,
  },
  {
    "shaunsingh/solarized.nvim",
    priority = 1000,
  },
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
  },
  {
    "shaunsingh/moonlight.nvim",
    priority = 1000,
  },
  -- Development tools
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local rt = require "rust-tools"
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
    ft = { "toml" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("crates").setup {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      }
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
        -- Rust
        "rust",
        "toml",
        -- Python
        "python",
        -- Gleam
        "gleam",
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
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    config = function()
      require("trouble").setup({
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = true, -- use icons for diagnostics
        mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        group = true, -- group results by file
        padding = true, -- add an extra new line on top of the list
        action_keys = { -- key mappings for actions in the trouble list
          close = "q", -- close the list
          cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
          refresh = "r", -- manually refresh
          jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
          open_split = { "<c-x>" }, -- open buffer in new split
          open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
          open_tab = { "<c-t>" }, -- open buffer in new tab
          toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
          hover = "K", -- opens a small popup with the full multiline message
          preview = "p", -- preview the diagnostic location
          close_folds = {"zM", "zm"}, -- close all folds
          open_folds = {"zR", "zr"}, -- open all folds
          toggle_fold = {"zA", "za"}, -- toggle fold of current file
          previous = "k", -- previous item
          next = "j" -- next item
        },
        signs = {
          -- icons / text used for a diagnostic
          error = "",
          warning = "",
          hint = "",
          information = "",
          other = "﫠"
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  -- Python-specific plugins
  {
    "goerz/jupytext.vim",
    ft = { "python", "ipynb" },
    init = function()
      vim.g.jupytext_fmt = "py:percent"
      vim.g.jupytext_style = "hydrogen"
    end,
  },
  {
    "hkupty/iron.nvim",
    ft = { "python" },
    config = function()
      require("iron.core").setup {
        config = {
          repl_definition = {
            python = {
              command = function()
                local venv = vim.fn.getenv("VIRTUAL_ENV")
                if venv ~= "" then
                  return { venv .. "/bin/ipython" }
                else
                  return { "ipython" }
                end
              end,
              format = require("iron.fts.common").bracketed_paste,
            },
          },
          repl_open_cmd = "botright 15 split",
          highlight = {
            italic = true,
          },
        },
        keymaps = {
          send_motion = "<leader>sc",
          visual_send = "<leader>sc",
          send_file = "<leader>sf",
          send_line = "<leader>sl",
          send_mark = "<leader>sm",
          mark_motion = "<leader>mc",
          mark_visual = "<leader>mc",
          remove_mark = "<leader>md",
          cr = "<leader>s<cr>",
          interrupt = "<leader>s<space>",
          exit = "<leader>sq",
          clear = "<leader>cl",
        },
      }
    end,
  },
  {
    "kiyoon/jupynium.nvim",
    build = "pip3 install --user .",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("jupynium").setup({
        python_host = {
          python_path = function()
            if vim.env.VIRTUAL_ENV then
              return vim.env.VIRTUAL_ENV .. '/bin/python'
            end
            return 'python3'
          end,
        },
      })
    end,
  },
  {
    "dccsillag/magma-nvim",
    build = "pip3 install --user pynvim && UpdateRemotePlugins",
    ft = { "python" },
    config = function()
      vim.g.magma_automatically_open_output = true
      vim.g.magma_image_provider = "kitty"
      -- Set keybindings
      vim.keymap.set('n', '<leader>mi', '<cmd>MagmaInit<CR>', { desc = "Initialize Magma" })
      vim.keymap.set('n', '<leader>mc', '<cmd>MagmaEvaluateOperator<CR>', { desc = "Evaluate Magma Cell" })
      vim.keymap.set('n', '<leader>ml', '<cmd>MagmaEvaluateLine<CR>', { desc = "Evaluate Line" })
      vim.keymap.set('x', '<leader>ms', '<cmd>MagmaEvaluateVisual<CR>', { desc = "Evaluate Visual Selection" })
      vim.keymap.set('n', '<leader>mo', '<cmd>MagmaShowOutput<CR>', { desc = "Show Output" })
      vim.keymap.set('n', '<leader>mq', '<cmd>noautocmd MagmaEnterOutput<CR>', { desc = "Enter Output" })
    end,
  },
}

return plugins
