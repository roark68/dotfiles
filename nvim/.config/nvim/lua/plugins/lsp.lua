local servers = {}
for _, path in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lsp/*.lua", false, true)) do
  local name = vim.fn.fnamemodify(path, ":t:r")
  servers[#servers + 1] = name
  vim.lsp.config(name, dofile(path))
end

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_enable = false,
})

vim.lsp.enable(servers)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local fzf = require("fzf-lua")
    local map = require("config.functions").bufmap(args.buf)

    local function goto_picker(fn)
      return function()
        fn({ jump1 = true, ignore_current_line = true })
      end
    end

    map("n", "gd", goto_picker(fzf.lsp_definitions), "Goto Definition")
    map("n", "gr", goto_picker(fzf.lsp_references), "References")
    map("n", "gI", goto_picker(fzf.lsp_implementations), "Goto Implementation")
    map("n", "gy", goto_picker(fzf.lsp_typedefs), "Goto Type Definition")

    map({ "n", "x" }, "<leader>ca", require("tiny-code-action").code_action, "Code Action")
    map("n", "<leader>ss", fzf.lsp_document_symbols, "Document Symbols")

    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
    map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh Codelens")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")

    map({ "n", "x" }, "<leader>fm", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, "Format Buffer")

    if client and client:supports_method("textDocument/signatureHelp") then
      map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
      map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
    end

    if client and vim.lsp.inlay_hint and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end
  end,
})
