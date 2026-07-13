return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "leoluz/nvim-dap-go",
    },
    config = function()
      local mason_dap = require "mason-nvim-dap"
      local dap = require "dap"
      local ui = require "dapui"
      local dap_virtual_text = require "nvim-dap-virtual-text"
      require("dap-go").setup()
      local cwd = vim.fn.getcwd()
      local venv_path = cwd .. "/venv/bin/python"

      -- Dap Virtual Text
      dap_virtual_text.setup()

      mason_dap.setup {
        ensure_installed = { "cppdbg", "python", "delve" },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
          -- Skip default handler for Python; we configure it manually below
          python = function() end,
        },
      }

      -- Python adapter (debugpy installed by Mason)
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python",
        args = { "-m", "debugpy.adapter" },
      }

      -- Configurations
      dap.configurations = {
        c = {
          {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            MIMode = "lldb",
          },
          {
            name = "Attach to lldbserver :1234",
            type = "cppdbg",
            request = "launch",
            MIMode = "lldb",
            miDebuggerServerAddress = "localhost:1234",
            miDebuggerPath = "/usr/bin/lldb",
            cwd = "${workspaceFolder}",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
          },
        },
        go = {
          {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}",
          },
          {
            type = "go",
            name = "Debug (with args)",
            request = "launch",
            program = "${file}",
            args = function()
              local args_str = vim.fn.input("Args: ")
              return vim.split(args_str, " ")
            end,
          },
          {
            type = "go",
            name = "Debug test",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
          },
        },
        python = {
          {
            -- The first three options are required by nvim-dap
            type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = "launch",
            name = "Launch file",
            console = "integratedTerminal",

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}", -- This configuration will launch the current file if used.
            cwd = function()
              -- Use the directory of the file being debugged as cwd.
              -- Falls back to Neovim's cwd if the file has no parent dir.
              local filepath = vim.fn.expand "%:p:h"
              if filepath ~= "" then
                return filepath
              end
              return vim.fn.getcwd()
            end,
            env = {
              -- Add the project root to PYTHONPATH so sibling/parent module imports work.
              PYTHONPATH = vim.fn.getcwd(),
            },
            pythonPath = function()
              local filedir = vim.fn.expand "%:p:h"
              local project_root = vim.fn.getcwd()

              -- Check the file's directory first, then walk up to project root
              local dirs = { filedir, project_root }
              for _, dir in ipairs(dirs) do
                print("[DAP] Checking: " .. dir .. "/venv/bin/python -> " .. tostring(vim.fn.executable(dir .. "/venv/bin/python")))
                print("[DAP] Checking: " .. dir .. "/.venv/bin/python -> " .. tostring(vim.fn.executable(dir .. "/.venv/bin/python")))
                if vim.fn.executable(dir .. "/venv/bin/python") == 1 then
                  print("[DAP] Found venv: " .. dir .. "/venv/bin/python")
                  return dir .. "/venv/bin/python"
                elseif vim.fn.executable(dir .. "/.venv/bin/python") == 1 then
                  print("[DAP] Found .venv: " .. dir .. "/.venv/bin/python")
                  return dir .. "/.venv/bin/python"
                end
              end
              print("[DAP] No venv found, falling back")

              -- Fall back to VIRTUAL_ENV if set, then system python
              if vim.env.VIRTUAL_ENV then
                print("[DAP] using VIRTUAL_ENV variable")
                return vim.env.VIRTUAL_ENV .. "/bin/python"
              end
              print("[DAP] No venv found")
              return "/usr/bin/python"
            end,
          },
        },
      }

      -- Dap UI

      ui.setup {
        layouts = {
          {
            -- LEFT SIDEBAR
            elements = {
              { id = "scopes",      size = 0.35 },
              { id = "breakpoints", size = 0.2 },
              { id = "repl",     size = 0.45 },
            },
            size = 50,         -- width of sidebar (in columns)
            position = "left", -- can be "left" or "right"
          },
          {
            -- BOTTOM PANEL
            elements = {
              { id = "console", size = 1.0 },
            },
            size = 12,           -- height of bottom panel (in lines)
            position = "bottom", -- "bottom" or "top"
          },
        },
      }

      vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end

      -- Key maps
    end,
  },
}
