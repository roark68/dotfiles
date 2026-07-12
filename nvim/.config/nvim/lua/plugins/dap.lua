local dapui = require("dapui")
local dap = require("dap")

-- https://emojipedia.org/en/stickers/search?q=circle
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

-- more minimal ui
dapui.setup({
  expand_lines = true,
  controls = { enabled = true }, -- no extra play/step buttons
  floating = { border = "rounded" },
  -- Set dapui window
  render = {
    max_type_length = 60,
    max_value_lines = 200,
  },
  -- Only one layout: just the "scopes" (variables) list at the bottom
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.7 }, -- 70% of this panel is scopes
        { id = "console", size = 0.3 }, -- 30% of this panel is scopes
      },
      size = 15,                       -- height in lines (adjust to taste)
      position = "bottom",             -- "left", "right", "top", "bottom"
    },
  },
})

-- open the ui as soon as we are debugging
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- Keymaps

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

-- F5        Start / Continue
-- Shift+F5  Stop
-- Ctrl+F5   Restart
-- F6        Pause
-- F9        Toggle breakpoint
-- F10       Step over
-- F11       Step into
-- Shift+F11 Step out
map("<F5>", dap.continue, "Debug: start/continue")
map("<S-F5>", dap.terminate, "Debug: stop")
map("<C-F5>", dap.restart, "Debug: restart")
map("<F6>", dap.pause, "Debug: pause")
map("<F9>", dap.toggle_breakpoint, "Debug: toggle breakpoint")
map("<F10>", dap.step_over, "Debug: step over")
map("<F11>", dap.step_into, "Debug: step into")
map("<S-F11>", dap.step_out, "Debug: step out")

-- Conditional breakpoint (VS Code: right-click > Add Conditional Breakpoint)
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


