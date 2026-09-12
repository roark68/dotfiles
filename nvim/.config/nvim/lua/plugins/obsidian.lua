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

-- Keymaps
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = "Obsidian: " .. desc })
end

map("n", ";?", "<cmd>Obsidian<cr>", "Command menu")

map("n", ";n", "<cmd>Obsidian new<cr>", "New note in Inbox")
map("n", ";q", "<cmd>Obsidian quick_switch<cr>", "Quick switch note")
map("n", ";s", "<cmd>Obsidian search<cr>", "Search notes")
map("n", ";g", "<cmd>Obsidian tags<cr>", "Search tags")
map("n", ";u", "<cmd>Obsidian unique_note<cr>", "New unique note")

map("n", ";t", "<cmd>Obsidian today<cr>", "Today journal")
map("n", ";y", "<cmd>Obsidian yesterday<cr>", "Yesterday journal")
map("n", ";m", "<cmd>Obsidian tomorrow<cr>", "Tomorrow journal")
map("n", ";d", "<cmd>Obsidian dailies<cr>", "Daily notes picker")

map("n", ";o", "<cmd>Obsidian open<cr>", "Open in Obsidian app")
map("n", ";b", "<cmd>Obsidian backlinks<cr>", "Backlinks")
map("n", ";l", "<cmd>Obsidian links<cr>", "Links in note")
map("n", ";f", "<cmd>Obsidian follow_link<cr>", "Follow link")
map("n", ";r", "<cmd>Obsidian rename<cr>", "Rename note")
map("n", ";c", "<cmd>Obsidian toggle_checkbox<cr>", "Toggle checkbox")
map("n", ";i", "<cmd>Obsidian paste_img<cr>", "Paste copied image")
map("n", ";h", "<cmd>Obsidian toc<cr>", "Table of contents")
map("n", ";p", "<cmd>MarkdownPreviewToggle<cr>", "Toggle browser preview (Zen)")

map("x", ";l", ":Obsidian link<cr>", "Link selection")
map("x", ";n", ":Obsidian link_new<cr>", "New linked note from selection")
map("x", ";e", ":Obsidian extract_note<cr>", "Extract selection to note")
