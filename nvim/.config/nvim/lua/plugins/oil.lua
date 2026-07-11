require("oil").setup({
  default_file_explorer = true,
  columns = { "icon" },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true, -- no prompt for small rename/move edits
  view_options = {
    show_hidden = true, -- show .env, .gitignore, etc.
    is_always_hidden = function(name, _)
      return name == "node_modules"
          or name == ".next"
          or name == "dist"
          or name == ".git"
          or name == ".cache"
          or name == ".vscode"
          or name == ".idea"
          or name == "obj"
          or name == "bin"
          or name == "build"
    end,
  },
  float = {
    padding = 2,
    max_width = 0.5,
    max_height = 0.8,
    preview_split = "below",
  },
  preview_win = {
    update_on_cursor_moved = true,
    preview_method = "fast_scratch",
  },
  keymaps = {
    ["<Esc>"] = "actions.close",
    ["q"] = "actions.close",
    ["<CR>"] = "actions.select",
    ["-"] = "actions.parent",
    ["\\"] = "actions.select_vsplit",
    ["="] = "actions.select_split",
    ["<C-r>"] = "actions.refresh",
    ["~"] = "actions.open_cwd",
    ["<C-p>"] = "actions.preview",
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
