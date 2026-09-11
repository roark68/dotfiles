local busy = {}

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(args)
    local id = args.data.client_id
    local kind = args.data.params.value.kind
    local delta = kind == "begin" and 1 or kind == "end" and -1 or 0
    busy[id] = math.max((busy[id] or 0) + delta, 0)
    vim.cmd.redrawstatus()
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    busy[args.data.client_id] = nil
  end,
})

local function clients_lsp()
  local names = {}
  for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if (busy[client.id] or 0) == 0 then
      table.insert(names, client.name)
    end
  end

  if #names == 0 then
    return ""
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
