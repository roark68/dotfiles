local vue_plugin_location = vim.fn.stdpath("data") ..
    "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local vue_root_markers = { "vue.config.js" }
local vue_plugin = nil
if vim.uv.fs_stat(vue_plugin_location) then
  vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vue_plugin_location,
    languages = { "vue" },
    configNamespace = "typescript",
    enableForWorkspaceTypeScriptVersions = true,
  }
end

local servers = {
  clangd = {},
  vtsls = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "vue"
    },
    settings = {
      complete_function_calls = true,
      vtsls = {
        tsserver = {
          globalPlugins = vue_plugin and { vue_plugin } or {},
        },
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        preferences = {
          importModuleSpecifier = "non-relative",
        },
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
      javascript = {
        preferences = {
          importModuleSpecifier = "non-relative",
        },
      },
    },
  },
  vue_ls = {
    root_markers = vue_root_markers,
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
}

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_enable = false,
})

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

-- LSP keymap
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local has_fzf, fzf = pcall(require, "fzf-lua")
    local map = require("config.functions").bufmap(args.buf)
    local format_buffer = function()
      local has_conform, conform = pcall(require, "conform")
      if has_conform then
        conform.format({ async = true, lsp_format = "fallback" })
        return
      end

      vim.lsp.buf.format({ async = true })
    end

    if has_fzf then
      map("n", "gd", function()
        fzf.lsp_definitions({
          jump1 = true,
          ignore_current_line = true,
          -- async_or_timeout = true,
        })
      end, "Goto Definition")
      map("n", "gr", function()
        fzf.lsp_references({
          jump1 = true,
          ignore_current_line = true,
          -- async_or_timeout = true,
        })
      end, "References")
      map("n", "gI", function()
        fzf.lsp_implementations({
          jump1 = true,
          ignore_current_line = true,
          -- async_or_timeout = true,
        })
      end, "Goto Implementation")
      map("n", "gy", function()
        fzf.lsp_typedefs({
          jump1 = true,
          ignore_current_line = true,
          -- async_or_timeout = true,
        })
      end, "Goto Type Definition")

      map("n", "<leader>ca", fzf.lsp_code_actions, "Code Action")
      map("n", "<leader>ss", fzf.lsp_document_symbols, "Document Symbols")
    else
      map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
      map("n", "gr", vim.lsp.buf.references, "References")
      map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
      map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")

      map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
      map("n", "<leader>ss", vim.lsp.buf.document_symbol, "Document Symbols")
    end

    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("x", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
    map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh Codelens")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
    -- Buffer-local override of the global <leader>fm (conform.lua): LSP buffers
    -- format via conform with LSP fallback. Intentional duplicate.
    map({ "n", "x" }, "<leader>fm", format_buffer, "Format Buffer")

    if client and client:supports_method("textDocument/signatureHelp") then
      map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
      map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
    end

    if client and vim.lsp.inlay_hint and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end
  end,
})
