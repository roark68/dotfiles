-- oil.nvim stays the directory/netrw editor (`-`); neo-tree is the side panel.
vim.g.neo_tree_remove_legacy_commands = 1

require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  open_files_do_not_replace_types = { "terminal", "trouble", "qf", "notify" },

  default_component_configs = {
    indent = {
      with_expanders = true,
      expander_collapsed = "",
      expander_expanded = "",
    },
    git_status = {
      symbols = {
        added = "",
        modified = "",
        deleted = "✖",
        renamed = "󰁕",
        untracked = "",
        ignored = "",
        unstaged = "󰄱",
        staged = "",
        conflict = "",
      },
    },
  },

  window = {
    position = "right",
    width = 36,
    mappings = {
      ["<space>"] = "none", -- keep <leader> usable inside the tree
      ["<CR>"] = "open",
      ["<Esc>"] = "cancel",
      ["l"] = "open",
      ["h"] = "close_node",
      ["\\"] = "open_vsplit",
      ["="] = "open_split",
      ["P"] = { "toggle_preview", config = { use_float = true } },
      ["H"] = "toggle_hidden",
      ["/"] = "fuzzy_finder",
      ["R"] = "refresh",
      ["a"] = { "add", config = { show_path = "relative" } },
      ["A"] = "add_directory",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy",
      ["m"] = "move",
      ["q"] = "close_window",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
    },
  },

  filesystem = {
    bind_to_cwd = false,
    cwd_target = { sidebar = "tab", current = "window" },
    follow_current_file = { enabled = true, leave_dirs_open = true },
    use_libuv_file_watcher = true,
    hijack_netrw_behavior = "disabled", -- oil.nvim owns netrw
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_by_name = { "node_modules", "obj", "bin" },
      never_show = { ".git", ".DS_Store" },
    },
    window = {
      mappings = {
        ["-"] = "navigate_up",
        ["."] = "set_root",
        ["<C-h>"] = "none", -- keep herdr/tmux window navigation
      },
    },
  },

  buffers = {
    follow_current_file = { enabled = true, leave_dirs_open = true },
    window = {
      mappings = {
        ["-"] = "navigate_up",
        ["."] = "set_root",
        ["bd"] = "buffer_delete",
      },
    },
  },

  git_status = {
    window = {
      mappings = {
        ["ga"] = "git_add_file",
        ["gu"] = "git_unstage_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
      },
    },
  },

  event_handlers = {
    {
      -- close the panel after opening a file, like a picker
      event = "file_opened",
      handler = function()
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
})

local map = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
end

map("<leader>e", "<CMD>Neotree toggle filesystem right<CR>", "Explorer (neo-tree)")
map("<leader>E", "<CMD>Neotree reveal filesystem right<CR>", "Explorer: reveal current file")
map("<leader>ne", "<CMD>Neotree focus filesystem right<CR>", "Explorer: focus")
map("<leader>nb", "<CMD>Neotree toggle buffers right<CR>", "Explorer: buffers")
map("<leader>ng", "<CMD>Neotree toggle git_status right<CR>", "Explorer: git status")
map("<leader>ns", "<CMD>Neotree toggle document_symbols right<CR>", "Explorer: document symbols")
map("<leader>nc", "<CMD>Neotree close<CR>", "Explorer: close")
