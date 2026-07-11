local notify = require("notify")

notify.setup({
  stages = "fade",
  timeout = 2000,
  render = "wrapped-compact",
  background_colour = "#000000"
})


vim.notify = notify

-- Dismiss all visible notifications
vim.keymap.set("n", "<leader>un", function()
  notify.dismiss({ silent = true, pending = true })
end, { desc = "Dismiss notifications" })

local progress = {}

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    local value = ev.data.params.value
    local kind = value.kind
    local title = value.title or "LSP"
    local message = value.message or ""
    local percent = value.percentage and (" (" .. value.percentage .. "%%)") or ""
    local text = title .. percent
    if message ~= "" then
      text = text .. "\n" .. message
    end

    local key = client.id .. ":" .. tostring(ev.data.params.token)
    local level = vim.log.levels.INFO
    local existing = progress[key]
    local id
    local opts = {
      title = client.name,
      timeout = false,
      on_close = function()
        if progress[key] == id then
          progress[key] = nil
        end
      end,
    }

    if existing then
      opts.replace = existing
    end

    if kind == "end" then
      opts.timeout = 1200
    end

    id = vim.notify(text, level, opts)
    progress[key] = id
  end,
})
