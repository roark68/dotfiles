local scheme = "catppuccin"

require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  float = {
    transparent = true,
    solid = false,
  },
})

require("everforest").setup({
  background = "medium",
  transparent_background_level = 2,
  italics = true,
  float_style = "dim",
})

vim.cmd.colorscheme(scheme)
