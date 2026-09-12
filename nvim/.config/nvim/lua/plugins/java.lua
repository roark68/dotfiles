vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  once = true,
  callback = function()
    require("java").setup({
      jdk = { auto_install = false, path = "/usr/lib/jvm/default" },
    })
    vim.lsp.enable("jdtls")
  end,
})
