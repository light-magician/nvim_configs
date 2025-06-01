require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Trouble.nvim mappings for better diagnostic navigation
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble diagnostics" })
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix list" })
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Location list" })

-- Debug mappings
map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debug continue" })
map("n", "<leader>do", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debug step over" })
map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debug step into" })
map("n", "<leader>ds", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debug step out" })
map("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "Debug REPL" })
map("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Debug UI" })

-- Language specific debug
map("n", "<leader>dpr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Run last debug config" })

-- Debug current file based on filetype
map("n", "<leader>dpd", function()
  local filetype = vim.bo.filetype
  if filetype == "rust" then
    require('dap').run({type = "codelldb", name = "Launch file", request = "launch"})
  elseif filetype == "python" then
    require('dap').run({type = "python", name = "Launch file", request = "launch"})
  elseif filetype == "javascript" or filetype == "typescript" then
    require('dap').run({type = "node2", name = "Launch file", request = "launch"})
  elseif filetype == "gleam" then
    require('dap').run({type = "node2", name = "Debug Gleam (via Node)", request = "launch"}) 
  else
    vim.notify("No debug configuration for filetype: " .. filetype, vim.log.levels.WARN)
  end
end, { desc = "Debug current file" })

-- Debug tests based on filetype
map("n", "<leader>dpt", function()
  local filetype = vim.bo.filetype
  if filetype == "rust" then
    require('dap').run({type = "codelldb", name = "Debug Current Test", request = "launch"})
  elseif filetype == "python" then
    require('dap').run({type = "python", name = "Debug Tests (pytest)", request = "launch"})
  else
    vim.notify("No test debug configuration for filetype: " .. filetype, vim.log.levels.WARN)
  end
end, { desc = "Debug current test" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Python-specific mappings
map("n", "<leader>pr", "<cmd>IronRepl<CR>", { desc = "Start Python REPL" })
map("n", "<leader>pf", "<cmd>IronFocus<CR>", { desc = "Focus REPL" })
map("n", "<leader>ph", "<cmd>IronHide<CR>", { desc = "Hide REPL" })

-- Jupynium mappings for Jupyter notebook integration
map("n", "<leader>jn", "<cmd>JupyniumStartSync<CR>", { desc = "Start Jupynium sync" })
map("n", "<leader>js", "<cmd>JupyniumStopSync<CR>", { desc = "Stop Jupynium sync" })
map("n", "<leader>jc", "<cmd>JupyniumClearOutput<CR>", { desc = "Clear Jupyter outputs" })
map("n", "<leader>jr", "<cmd>JupyniumExecuteCell<CR>", { desc = "Run Jupyter cell" })

-- Toggle transparency
map("n", "<leader>tt", function()
  local chadrc = require("chadrc")
  chadrc.base46.transparency = not chadrc.base46.transparency
  require("base46").load_theme(chadrc.base46.theme)
  vim.notify("Transparency: " .. (chadrc.base46.transparency and "ON" or "OFF"))
end, { desc = "Toggle transparency" })
