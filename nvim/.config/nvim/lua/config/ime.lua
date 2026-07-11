local M = {}

local function trim(value)
  return (value or ""):gsub("%s+", "")
end

local function detect_backend()
  if vim.fn.executable("fcitx5-remote") == 1 then
    return "fcitx5"
  end

  if vim.fn.executable("im-select.exe") == 1 then
    return "im-select.exe"
  end

  if vim.fn.executable("im-select") == 1 then
    return "im-select"
  end

  return nil
end

local backend = detect_backend()
if not backend then
  return M
end

local english_layout = tostring(vim.g.im_english_layout or "1033")

local function run(cmd)
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return trim(output)
end

local get_current
local set_english
local restore_last

if backend == "fcitx5" then
  local function is_on()
    return run("fcitx5-remote") == "2"
  end

  local last_insert_on = is_on()

  get_current = function()
    return is_on() and "on" or "off"
  end

  set_english = function()
    vim.fn.system("fcitx5-remote -c")
  end

  restore_last = function()
    if last_insert_on then
      vim.fn.system("fcitx5-remote -o")
    end
  end

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("SmartIME", { clear = true }),
    callback = function()
      last_insert_on = get_current() == "on"
      set_english()
    end,
  })
else
  local function set_layout(layout)
    run({ backend, tostring(layout) })
  end

  get_current = function()
    return run(backend)
  end

  set_english = function()
    set_layout(english_layout)
  end

  local last_insert_layout = get_current() or english_layout

  restore_last = function()
    if last_insert_layout and last_insert_layout ~= english_layout then
      set_layout(last_insert_layout)
    end
  end

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("SmartIME", { clear = true }),
    callback = function()
      last_insert_layout = get_current() or english_layout
      set_english()
    end,
  })
end

vim.api.nvim_create_autocmd("InsertEnter", {
  group = "SmartIME",
  callback = restore_last,
})

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = "SmartIME",
  callback = set_english,
})

vim.api.nvim_create_autocmd("FocusGained", {
  group = "SmartIME",
  callback = restore_last,
})

return M
