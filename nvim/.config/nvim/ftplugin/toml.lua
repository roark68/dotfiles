require("config.functions").set_indent(2, true)

-- Neovim ships no indent/toml.vim; use the treesitter indents.scm instead.
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
