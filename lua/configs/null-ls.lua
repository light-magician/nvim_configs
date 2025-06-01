local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local sources = {
  formatting.prettier.with({
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "css",
      "scss",
      "less",
      "html",
      "json",
      "jsonc",
      "yaml",
      "markdown",
      "graphql",
      "handlebars",
    },
    extra_args = {"--single-quote", "--jsx-single-quote"}
  }),
  formatting.clang_format,
  
  -- ESLint support removed from null-ls - use nvim-lspconfig with eslint LSP instead
  
  -- Python-specific tools
  diagnostics.mypy.with({
    command = function()
      -- Try to find Poetry environment first
      local cwd = vim.fn.getcwd()
      if vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
        local handle = io.popen("cd " .. cwd .. " && poetry env info --path 2>/dev/null")
        if handle then
          local poetry_path = handle:read("*a"):gsub("%s+", "")
          handle:close()
          if poetry_path and poetry_path ~= "" and vim.fn.isdirectory(poetry_path) == 1 then
            local mypy_path = poetry_path .. "/bin/mypy"
            if vim.fn.executable(mypy_path) == 1 then
              return mypy_path
            end
          end
        end
      end
      -- Fallback to system mypy
      return "mypy"
    end,
  }), -- Enhanced type checking for Python
}

local options = {
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}

return options
