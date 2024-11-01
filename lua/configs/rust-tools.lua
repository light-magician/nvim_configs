-- lua/configs/rust-tools.lua
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local options = {
  server = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.cmd("autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require('rust-tools').inlay_hints.enable()")
    end,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
        cargo = {
          allFeatures = true,
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
  tools = {
    inlay_hints = {
      auto = true,
      only_current_line = false,
      show_parameter_hints = true,
      parameter_hints_prefix = "<-",
      other_hints_prefix = "=>",
    },
  },
}

return options
