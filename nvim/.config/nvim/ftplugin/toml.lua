require("config.functions").set_indent(2, true)

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
