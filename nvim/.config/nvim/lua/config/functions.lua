local M = {}

-- Delete the current buffer without closing the window/split it lives in.
-- Each window showing the buffer is switched to the alternate buffer (or a
-- previous/new buffer) first, then the buffer is wiped.
function M.buf_delete()
  local cur = vim.api.nvim_get_current_buf()

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == cur then
      vim.api.nvim_win_call(win, function()
        -- Prefer the alternate buffer if it's listed and valid.
        local alt = vim.fn.bufnr("#")
        if alt > 0 and alt ~= cur and vim.fn.buflisted(alt) == 1 then
          vim.cmd("buffer #")
        else
          vim.cmd("bprevious")
        end
        -- Still on the doomed buffer (it was the only one) -> open a blank one.
        if vim.api.nvim_win_get_buf(win) == cur then
          vim.cmd("enew")
        end
      end)
    end
  end

  -- Now safe to delete; window layout is preserved.
  if vim.api.nvim_buf_is_valid(cur) then
    vim.cmd("bdelete! " .. cur)
  end
end

function M.pack_clean()
  local active_plugins = {}
  local unused_plugins = {}

  for _, plugin in ipairs(vim.pack.get()) do
    active_plugins[plugin.spec.name] = plugin.active
  end

  for _, plugin in ipairs(vim.pack.get()) do
    if not active_plugins[plugin.spec.name] then
      table.insert(unused_plugins, plugin.spec.name)
    end
  end

  if #unused_plugins == 0 then
    print("No unused plugins.")
    return
  end

  local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.pack.del(unused_plugins)
  end
end

-- Return a buffer-local keymap setter. Pass a bufnr, or nil/omit for the
-- current buffer. Used by ftplugins and the LspAttach handler.
function M.bufmap(buf)
  return function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf or true, silent = true, desc = desc })
  end
end

-- Set buffer-local indentation and register an undo_ftplugin entry so the
-- settings revert when the filetype changes. `expand` is optional; when nil
-- the buffer keeps its current expandtab value.
function M.set_indent(size, expand)
  vim.bo.tabstop = size
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
  if expand ~= nil then
    vim.bo.expandtab = expand
  end
  vim.b.undo_ftplugin = "setlocal tabstop< shiftwidth< softtabstop< expandtab<"
end

return M
