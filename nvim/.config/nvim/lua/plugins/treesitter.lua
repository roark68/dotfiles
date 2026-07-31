require('nvim-treesitter').install {
  'lua',
  'rust',
  'javascript',
  'zig',
  'yaml',
  'toml'
}

-- nvim-treesitter (main) only installs parsers. Neovim auto-starts treesitter
-- highlighting for its bundled filetypes only (lua/markdown/query/help), so
-- everything else stays on regex syntax unless we start it here.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if not lang then
      return
    end

    local ok, added = pcall(vim.treesitter.language.add, lang)
    if not ok or added == false then
      return
    end

    pcall(vim.treesitter.start, args.buf, lang)
  end,
})
