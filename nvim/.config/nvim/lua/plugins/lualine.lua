local function clients_lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if not clients or next(clients) == nil then
    return ""
  end

  local names = {}
  for _, client in pairs(clients) do
    table.insert(names, client.name)
  end
  return " " .. table.concat(names, "|")
end

local function pretty_path()
  local path = vim.fn.expand("%:~:.")
  if path == "" then
    return "[No Name]"
  end
  return path
end

local function git_root_folder()
  local root = vim.fs.root(0, ".git")
  if not root then
    return ""
  end
  return " " .. vim.fn.fnamemodify(root, ":t")
end

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {
      { "mode" },
    },
    lualine_b = {
      { "branch", icon = "" },
    },
    lualine_c = {
      {
        "diagnostics",
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = " ",
        },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      { pretty_path },
    },
    lualine_x = {
      clients_lsp,
      {
        "diff",
        symbols = {
          added = "+",
          modified = "~",
          removed = "-",
        },
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      },
    },
    lualine_y = {
      { "progress", separator = " ", icon = "", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    },
    lualine_z = {
      git_root_folder,
    },
  },
})
