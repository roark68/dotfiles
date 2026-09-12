local M = {}

--- Delete the current buffer while keeping its window(s) open,
--- falling back to the alternate buffer, the previous one, then a new empty one.
function M.buf_delete()
  local cur = vim.api.nvim_get_current_buf()

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == cur then
      vim.api.nvim_win_call(win, function()
        local alt = vim.fn.bufnr("#")
        if alt > 0 and alt ~= cur and vim.fn.buflisted(alt) == 1 then
          vim.cmd("buffer #")
        else
          vim.cmd("bprevious")
        end

        if vim.api.nvim_win_get_buf(win) == cur then
          vim.cmd("enew")
        end
      end)
    end
  end

  if vim.api.nvim_buf_is_valid(cur) then
    vim.cmd("bdelete! " .. cur)
  end
end

--- Load every installed plugin, then check them all for updates.
function M.pack_update()
  pcall(vim.cmd, "PackAddAll")
  vim.pack.update()
end

--- Load every installed plugin, then prompt to remove the ones no longer in the pack list.
function M.pack_clean()
  pcall(vim.cmd, "PackAddAll")

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

--- Toggle LSP inlay hints for the current buffer.
function M.toggle_inlay_hint()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end

--- Return a keymap setter bound to `buf` (default: current buffer).
--- Usage: local map = bufmap(buf); map("n", "gd", fn, "Goto definition")
function M.bufmap(buf)
  return function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf or true, silent = true, desc = desc })
  end
end

--- Set buffer-local indent width, optionally toggling expandtab,
--- and register the matching undo_ftplugin. For ftplugins and :Indent.
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
