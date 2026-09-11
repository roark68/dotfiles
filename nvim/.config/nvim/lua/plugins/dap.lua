local dapui = require("dapui")
local dap = require("dap")

vim.fn.sign_define('DapBreakpoint',
  {
    text = '🔴',
    texthl = 'DapBreakpointSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })

vim.fn.sign_define('DapStopped',
  {
    text = '👉',
    texthl = 'yellow',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })
vim.fn.sign_define('DapBreakpointRejected',
  {
    text = '⭕',
    texthl = 'DapStoppedSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })

dapui.setup({
  expand_lines = true,

  controls = { enabled = true },
  floating = { border = "rounded" },

  render = {
    max_type_length = 60,
    max_value_lines = 200,
  },

  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.6 },
        { id = "repl", size = 0.4 },
      },
      size = 15,
      position = "bottom",
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

local netcoredbg = vim.fn.exepath("netcoredbg")
if netcoredbg == "" then
  netcoredbg = vim.fn.expand("~/.local/share/nvim/mason/bin/netcoredbg")
end

dap.adapters.coreclr = {
  type = "executable",
  command = netcoredbg,
  args = { "--interpreter=vscode" },
}

local function aspire_pid(project_path, label)
  return function()
    local utils = require("dap.utils")

    local function is_api(proc)
      return proc.name:find(project_path, 1, true) ~= nil
          and proc.name:find("/bin/", 1, true) ~= nil
          and proc.name:find("MSBuild", 1, true) == nil
    end

    local procs = utils.get_processes({ filter = is_api })
    if #procs == 0 then
      utils.notify(label .. " is not running -- start the stack with run-gateway", vim.log.levels.WARN)
      return dap.ABORT
    elseif #procs == 1 then
      return procs[1].pid
    end

    return utils.pick_process({ filter = is_api, prompt = "Select " .. label .. " process: " })
  end
end

local cs_configs = dap.configurations.cs or {}
for _, api in ipairs({
  { label = "needs-api", path = "/Needs/src/Api.Server/" },
  { label = "candidates-api", path = "/Candidates/src/Api.Server/" },
  { label = "joboffers-api", path = "/JobOffers/src/Api.Server/" },
}) do
  table.insert(cs_configs, {
    type = "coreclr",
    name = "attach: " .. api.label .. " (Aspire)",
    request = "attach",
    processId = aspire_pid(api.path, api.label),
  })
end

table.insert(cs_configs, {
  type = "coreclr",
  name = "attach: pick a .NET process",
  request = "attach",
  processId = function()
    return require("dap.utils").pick_process({
      filter = function(proc)
        return proc.name:find("dotnet", 1, true) ~= nil or proc.name:find("Api.Server", 1, true) ~= nil
      end,
    })
  end,
})

dap.configurations.cs = cs_configs

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

map("<F5>", dap.continue, "Debug: start/continue")

map("<S-F5>", function()
  local session = dap.session()
  if session and session.config and session.config.request == "attach" then
    dap.disconnect({ terminateDebuggee = false })
  else
    dap.terminate()
  end
end, "Debug: stop (detach when attached)")
map("<C-F5>", dap.restart, "Debug: restart")
map("<F6>", dap.pause, "Debug: pause")
map("<F9>", dap.toggle_breakpoint, "Debug: toggle breakpoint")
map("<F10>", dap.step_over, "Debug: step over")
map("<F11>", dap.step_into, "Debug: step into")
map("<S-F11>", dap.step_out, "Debug: step out")

map("<leader>da", function()
  local attachable = vim.tbl_filter(function(config)
    return config.type == "coreclr"
  end, dap.configurations.cs or {})

  vim.ui.select(attachable, {
    prompt = "Attach to:",
    format_item = function(config) return config.name end,
  }, function(choice)
    if choice then dap.run(choice) end
  end)
end, "Debug: attach to a running .NET API")

map("<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Debug: conditional breakpoint")

local mapV2, opts = vim.keymap.set, { noremap = true, silent = true }

mapV2("n", "<leader>du", function() dapui.toggle() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })

mapV2({ "n", "v" }, "<leader>dw", function() require("dapui").eval(nil, { enter = true }) end,
  { noremap = true, silent = true, desc = "Add word under cursor to Watches" })

mapV2({ "n", "v" }, "Q", function() require("dapui").eval() end,
  {
    noremap = true,
    silent = true,
    desc =
    "Hover/eval a single value (opens a tiny window instead of expanding the full object) "
  })
