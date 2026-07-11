local obsidian = require("obsidian")

if vim.g.obsidian_setup_done then
  return
end

local workspaces = {
  {
    name = "mantu",
    path = vim.fn.expand("~/mantu/Obsidian"),
  },
}

for _, workspace in ipairs(workspaces) do
  vim.fn.mkdir(workspace.path, "p")
end

local function note_id(title)
  if not title or title == "" then
    return tostring(os.time())
  end

  local id = title:gsub("[\\/:*?\"<>|]", "-"):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  return id ~= "" and id or tostring(os.time())
end

obsidian.setup({
  legacy_commands = false,
  completion = {
    create_new = true,
    min_chars = 1,
  },
  picker = {
    name = "fzf-lua",
  },
  workspaces = workspaces,
  notes_subdir = "Inbox",
  new_notes_location = "notes_subdir",
  note_id_func = note_id,
  daily_notes = {
    folder = "Journal",
    date_format = "YYYY-MM-DD",
    alias_format = "MMMM D, YYYY",
    default_tags = { "daily" },
    workdays_only = false,
  },
  footer = {
    enabled = false,
  },
  ui = {
    enable = false,
    ignore_conceal_warn = false,
    update_debounce = 200,
    max_file_length = 5000,
  },
})

vim.g.obsidian_setup_done = true

local function nmap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = "Obsidian: " .. desc })
end

local function xmap(lhs, rhs, desc)
  vim.keymap.set("x", lhs, rhs, { desc = "Obsidian: " .. desc })
end

nmap(";?", "<cmd>Obsidian<cr>", "Command menu")

nmap(";n", "<cmd>Obsidian new<cr>", "New note in Inbox")
nmap(";q", "<cmd>Obsidian quick_switch<cr>", "Quick switch note")
nmap(";s", "<cmd>Obsidian search<cr>", "Search notes")
nmap(";g", "<cmd>Obsidian tags<cr>", "Search tags")
nmap(";u", "<cmd>Obsidian unique_note<cr>", "New unique note")

nmap(";t", "<cmd>Obsidian today<cr>", "Today journal")
nmap(";y", "<cmd>Obsidian yesterday<cr>", "Yesterday journal")
nmap(";m", "<cmd>Obsidian tomorrow<cr>", "Tomorrow journal")
nmap(";d", "<cmd>Obsidian dailies<cr>", "Daily notes picker")

nmap(";o", "<cmd>Obsidian open<cr>", "Open in Obsidian app")
nmap(";b", "<cmd>Obsidian backlinks<cr>", "Backlinks")
nmap(";l", "<cmd>Obsidian links<cr>", "Links in note")
nmap(";f", "<cmd>Obsidian follow_link<cr>", "Follow link")
nmap(";r", "<cmd>Obsidian rename<cr>", "Rename note")
nmap(";c", "<cmd>Obsidian toggle_checkbox<cr>", "Toggle checkbox")
nmap(";i", "<cmd>Obsidian paste_img<cr>", "Paste copied image")
nmap(";h", "<cmd>Obsidian toc<cr>", "Table of contents")

xmap(";l", ":Obsidian link<cr>", "Link selection")
xmap(";n", ":Obsidian link_new<cr>", "New linked note from selection")
xmap(";e", ":Obsidian extract_note<cr>", "Extract selection to note")
