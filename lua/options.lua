require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Custom diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = '●', -- Could be '■', '▎', 'x', etc
    source = "if_many",
    spacing = 4,
  },
  float = {
    source = "always",
    border = "rounded",
    style = "minimal",
    max_width = 80,
    max_height = 20,
    focusable = true,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Add proper color support
vim.opt.termguicolors = true

-- Add keymap to show diagnostics in floating window that's easy to copy from
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float({ scope = "line", focusable = true })
end, { desc = "Show diagnostics in floating window" })

-- Improve filetype detection for special files
vim.filetype.add({
  filename = {
    [".env"] = "sh",
    [".env.local"] = "sh",
    [".env.development"] = "sh",
    [".env.production"] = "sh",
    [".env.test"] = "sh",
    ["package.json"] = "json",
    ["package-lock.json"] = "json",
    [".eslintrc"] = "json",
    [".prettierrc"] = "json",
    ["tsconfig.json"] = "jsonc",
    ["jsconfig.json"] = "jsonc",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
    ["%.config/[%w_.-]+"] = "json",
  },
})
