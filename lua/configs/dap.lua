-- lua/configs/dap.lua
local dap = require("dap")

-- Setup CODELLDB for Rust and C/C++
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = {"--port", "${port}"},
  }
}

-- Setup Node adapter for JavaScript and TypeScript
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {vim.fn.stdpath("data") .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}'},
}

-- Python adapter
dap.adapters.python = {
  type = 'executable',
  command = vim.fn.stdpath("data") .. '/mason/packages/debugpy/venv/bin/python',
  args = {'-m', 'debugpy.adapter'},
}

-- Rust configurations
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
    name = "Debug Current Test",
    type = "codelldb",
    request = "launch",
    program = function()
      -- Get current buffer content
      local test_name = nil
      local line_num = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      
      -- Find the test name
      for i = line_num, 1, -1 do
        local line = lines[i]
        local match = string.match(line, '#%[test%][^%S\n]*fn%s+([%w_]+)')
        if match then
          test_name = match
          break
        end
      end

      if not test_name then
        vim.notify("No test found above cursor", vim.log.levels.ERROR)
        return
      end

      -- Build the test
      local cmd = string.format("cargo test %s --no-run --message-format=json", test_name)
      local output = vim.fn.system(cmd)
      
      -- Parse JSON output to find executable
      for line in output:gmatch("[^\r\n]+") do
        local data = vim.json.decode(line)
        if data and data.executable then
          return data.executable
        end
      end
      
      vim.notify("Failed to find test executable", vim.log.levels.ERROR)
    end,
    args = function()
      local line_num = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      
      -- Find the test name
      for i = line_num, 1, -1 do
        local line = lines[i]
        local match = string.match(line, '#%[test%][^%S\n]*fn%s+([%w_]+)')
        if match then
          return {"--exact", match}
        end
      end
      return {}
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

-- Python configurations
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = "${file}",
    pythonPath = function()
      -- Try to detect python path from active virtual environment
      if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/python'
      end
      -- Return default python from PATH
      return 'python3'
    end,
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Launch with arguments',
    program = "${file}",
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      return vim.split(args_string, " ")
    end,
    pythonPath = function()
      if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/python'
      end
      return 'python3'
    end,
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Debug Tests (pytest)',
    module = 'pytest',
    args = function()
      local args_string = vim.fn.input('pytest args: ')
      return vim.split(args_string, " ")
    end,
    pythonPath = function()
      if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/python'
      end
      return 'python3'
    end,
  },
}

-- JavaScript and TypeScript configurations
dap.configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    cwd = '${workspaceFolder}',
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    type = 'node2',
    request = 'attach',
    name = 'Attach to process',
    processId = require('dap.utils').pick_process,
    cwd = '${workspaceFolder}',
    sourceMaps = true,
  },
}
dap.configurations.typescript = dap.configurations.javascript

-- Gleam configurations (using Node adapter as a proxy since there's no native Gleam debugger)
dap.configurations.gleam = {
  {
    type = 'node2',
    request = 'launch',
    name = 'Debug Gleam (via Node)',
    program = function()
      return vim.fn.input('Path to compiled JS: ', vim.fn.getcwd() .. '/build/', 'file')
    end,
    cwd = '${workspaceFolder}',
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  }
}

-- Debug keymaps

vim.api.nvim_set_keymap('n', '<leader>dt', [[:lua require"dap".run({name="Debug Current Test", type="codelldb", request="launch"})<CR>]], {noremap = true, desc = "Debug Current Test"})
vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require"dap".continue()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>do', ':lua require"dap".step_over()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>di', ':lua require"dap".step_into()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require"dap".step_out()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>db', ':lua require"dap".toggle_breakpoint()<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', {noremap = true})
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
