-- lua/configs/dap.lua
local dap = require("dap")

-- Setup CODELLDB
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = {"--port", "${port}"},
  }
}

dap.configurations.rust = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      local cargo_path = vim.fs.find('Cargo.toml', {
        upward = true,
        stop = vim.loop.os_homedir(),
      })[1]
      
      if cargo_path then
        local workspace_dir = vim.fs.dirname(cargo_path)
        local package_name = nil
        for line in io.lines(cargo_path) do
          local name = line:match('^name%s*=%s*"(.+)"')
          if name then
            package_name = name
            break
          end
        end
        if package_name then
          local targets = {
            workspace_dir .. "/target/debug/" .. package_name,
            workspace_dir .. "/target/release/" .. package_name
          }
          for _, target in ipairs(targets) do
            if vim.fn.executable(target) == 1 then
              return target
            end
          end
        end
      end
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return vim.split(args_string, " ")
    end,
    runInTerminal = false,
  },
  {
    name = "Launch test",
    type = "codelldb",
    request = "launch",
    program = function()
      local cargo_path = vim.fs.find('Cargo.toml', {
        upward = true,
        stop = vim.loop.os_homedir(),
      })[1]
      if cargo_path then
        return vim.fn.input('Path to test executable: ', vim.fs.dirname(cargo_path) .. '/target/debug/deps/', 'file')
      end
      return vim.fn.input('Path to test executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return vim.split(args_string, " ")
    end,
    runInTerminal = false,
  },
}

-- Debug keymaps
vim.api.nvim_set_keymap('n', '<F5>', ':lua require"dap".continue()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F10>', ':lua require"dap".step_over()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F11>', ':lua require"dap".step_into()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F12>', ':lua require"dap".step_out()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>b', ':lua require"dap".toggle_breakpoint()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>B', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>dr', ':lua require"dap".repl.open()<CR>', {noremap = true})

-- Setup DAP UI if available
local has_dap_ui, dapui = pcall(require, "dap-ui")
if has_dap_ui then
  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    layouts = {
      {
        elements = {
          'scopes',
          'breakpoints',
          'stacks',
          'watches',
        },
        size = 40,
        position = 'left',
      },
      {
        elements = {
          'repl',
          'console',
        },
        size = 10,
        position = 'bottom',
      },
    },
  })
  
  -- Automatically open UI
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end
