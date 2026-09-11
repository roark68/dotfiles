vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_theme = "dark"
vim.g.mkdp_echo_preview_url = 1

local zen = vim.fn.expand("~/.local/bin/mkdp-zen")

vim.g.mkdp_browserfunc = "MkdpOpenInZen"
vim.cmd(string.format(
  [[
function! MkdpOpenInZen(url) abort
  call jobstart(['%s', a:url], {'detach': v:true})
endfunction
]],
  zen
))

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function(args)
    vim.keymap.set("n", ";p", "<cmd>MarkdownPreviewToggle<cr>", {
      buffer = args.buf,
      desc = "Markdown: toggle browser preview (Zen)",
    })
  end,
})
