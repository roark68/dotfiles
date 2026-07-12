-- Dynamic SQL Server connection strings for local BE debugging (Needs / Candidates /
-- JobOffers). The Windows host lives at the WSL default-gateway IP, which can change
-- across `wsl --shutdown`. Compute it at startup and export ConnectionStrings__* into
-- the environment so easy-dotnet's `dotnet run` (http-dev profile) inherits them —
-- mirroring the run-needs / run-candidates / run-joboffers scripts without hardcoding
-- an IP in each repo's launchSettings.json.
--
-- Safe for integration tests: IntegrationTestWebAppFactory overrides
-- ConnectionStrings:SMARTAmaris in-memory (added after env) and calls UseSqlServer(...)
-- directly, so these env values are ignored by tests.
do
  local ip = vim.fn.system({ "sh", "-c", "ip route show default | awk '{print $3}'" }):gsub("%s+", "")
  if ip ~= "" then
    local cred = "User Id=marketplace_dev;Password=ChangeMe123!;MultipleActiveResultSets=true;TrustServerCertificate=Yes;App=mantu-nvim-debug"
    local function cs(db)
      return string.format("Server=%s,1433;Database=%s;%s", ip, db, cred)
    end
    -- Superset across the three BE repos; each app reads only the keys it needs.
    vim.env["ConnectionStrings__SMARTAmaris"] = cs("SMART_Amaris")
    vim.env["ConnectionStrings__ERPDocument"] = cs("ERP_Document")
    vim.env["ConnectionStrings__DocumentStaging"] = cs("Document_Staging")
    vim.env["ConnectionStrings__CDN"] = cs("CDN")
    vim.env["ConnectionStrings__ERP_CorporateFiles"] = cs("ERP_CorporateFiles")
  end
end

local dotnet = require("easy-dotnet")

if not vim.g._dotnet_workspace_edit_patch then
  local orig_apply_workspace_edit = vim.lsp.util.apply_workspace_edit
  vim.lsp.util.apply_workspace_edit = function(edit, position_encoding)
    if type(edit) == "table" and type(edit.documentChanges) == "table" then
      for _, change in ipairs(edit.documentChanges) do
        if type(change) == "table" and type(change.textDocument) == "table" and change.textDocument.version == nil then
          change.textDocument.version = vim.NIL
        end
      end
    end
    return orig_apply_workspace_edit(edit, position_encoding)
  end
  vim.g._dotnet_workspace_edit_patch = true
end

dotnet.setup({
  auto_bootstrap_namespace = {
    enabled = true,
    type = "block_scoped",
  },
  picker = "fzf",
})

local function create_dotnet_item(target_dir)
  if not target_dir or target_dir == "" then
    vim.notify("Cannot resolve target directory", vim.log.levels.WARN)
    return
  end
  dotnet.create_new_item(target_dir)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(args)
    -- <leader>dn (not <leader>a) so the Claude Code <leader>a* prefix stays free.
    vim.keymap.set("n", "<leader>dn", function()
      local ok, oil = pcall(require, "oil")
      if not ok then
        vim.notify("oil is not available", vim.log.levels.WARN)
        return
      end

      local target_dir = oil.get_current_dir(args.buf)
      local entry = oil.get_cursor_entry()

      if entry and entry.type == "file" and target_dir then
        target_dir = vim.fn.fnamemodify(target_dir .. "/" .. entry.name, ":h")
      end

      create_dotnet_item(target_dir)
    end, { buffer = args.buf, desc = "Create .NET item from template" })
  end,
})
