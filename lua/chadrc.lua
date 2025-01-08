-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "melange",

  -- enable this when you want it to be transparent
  hl_override = {
    -- Override the default background to be transparent
    Normal = { bg = "NONE" },
    NormalFloat = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    NvimTreeNormal = { bg = "NONE" },
    StatusLine = { bg = "NONE" },
    NeoTreeNormal = { bg = "NONE" },
    TelescopeNormal = { bg = "NONE" },

    -- You might also want these for consistent transparency
    NvimTreeEndOfBuffer = { bg = "NONE" },
    EndOfBuffer = { bg = "NONE" },

    -- Keep syntax highlighting while making background transparent
    Comment = { italic = true, bg = "NONE" },
    ["@comment"] = { italic = true, bg = "NONE" },
  },

  -- Ensure transparency is enabled
  transparency = true,
}

return M
