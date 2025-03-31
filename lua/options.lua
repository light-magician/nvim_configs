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

-- Make hover windows more readable with transparent themes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Set better background for floating windows
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1b26", blend = 10 })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1a1b26", fg = "#89b4fa", blend = 10 })
  end,
})

-- Add keymap to show diagnostics in floating window that's easy to copy from
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float({ scope = "line", focusable = true })
end, { desc = "Show diagnostics in floating window" })
