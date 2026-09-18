-- obsidian.nvim
local workspace = { name = "mantu", path = vim.fn.expand("~/mantu/Obsidian/") }

vim.fn.mkdir(workspace.path, "p")

local function note_id(title)
  local id = (title or ""):gsub('[\\/:*?"<>|]', "-"):gsub("%s+", " ")
  id = vim.trim(id)
  return id ~= "" and id or tostring(os.time())
end

require("obsidian").setup({
  legacy_commands = false,
  completion = { min_chars = 1 },
  picker = { name = "fzf-lua" },
  workspaces = { workspace },
  notes_subdir = "Inbox",
  new_notes_location = "notes_subdir",
  note_id_func = note_id,
  daily_notes = {
    folder = "Journal",
    alias_format = "MMMM D, YYYY",
    default_tags = { "daily" },
    workdays_only = false,
  },
  footer = { enabled = false },
  ui = { enable = false },
})

-- render-markdown.nvim
require("render-markdown").setup({
  completions = {
    lsp = { enabled = true },
    blink = { enabled = true },
  },
  win_options = { conceallevel = { rendered = 2 } },
})

-- markdown-preview.nvim
vim.g.mkdp_theme = "dark"
vim.g.mkdp_echo_preview_url = 1
vim.g.mkdp_browser = vim.fn.expand("~/.local/bin/mkdp-zen")

