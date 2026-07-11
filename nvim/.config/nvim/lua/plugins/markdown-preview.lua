-- markdown-preview.nvim: live preview markdown in the browser.
-- On WSL the preview server runs in Linux and Windows reaches it via
-- localhost forwarding. Instead of letting the node server spawn the
-- browser (unreliable on WSL), we set g:mkdp_browserfunc so the server
-- calls back into Neovim, which jobstart()s the Windows Zen Browser.

vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_theme = "dark"
vim.g.mkdp_echo_preview_url = 1

local zen = vim.fn.expand("~/.local/bin/mkdp-zen")

-- mkdp calls this Vim function name with the preview URL.
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
