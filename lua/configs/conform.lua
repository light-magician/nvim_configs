local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang-format" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    vue = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    handlebars = { "prettier" },
    python = { "isort", "black" }, -- isort first, then black
    gleam = { "gleam" }, -- use the Gleam compiler's format feature
  },
  
  formatters = {
    prettier = {
      prepend_args = { "--single-quote", "--jsx-single-quote" }
    },
    black = {
      command = function()
        -- Try to find Poetry environment first
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
          local handle = io.popen("cd " .. cwd .. " && poetry env info --path 2>/dev/null")
          if handle then
            local poetry_path = handle:read("*a"):gsub("%s+", "")
            handle:close()
            if poetry_path and poetry_path ~= "" and vim.fn.isdirectory(poetry_path) == 1 then
              local black_path = poetry_path .. "/bin/black"
              if vim.fn.executable(black_path) == 1 then
                return black_path
              end
            end
          end
        end
        -- Fallback to system black
        return "black"
      end,
    },
    isort = {
      command = function()
        -- Try to find Poetry environment first
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
          local handle = io.popen("cd " .. cwd .. " && poetry env info --path 2>/dev/null")
          if handle then
            local poetry_path = handle:read("*a"):gsub("%s+", "")
            handle:close()
            if poetry_path and poetry_path ~= "" and vim.fn.isdirectory(poetry_path) == 1 then
              local isort_path = poetry_path .. "/bin/isort"
              if vim.fn.executable(isort_path) == 1 then
                return isort_path
              end
            end
          end
        end
        -- Fallback to system isort
        return "isort"
      end,
    },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
