local ip = vim.fn.system({ "sh", "-c", "ip route show default | awk '{print $3}'" }):gsub("%s+", "")
if ip ~= "" then
  local cred = "User Id=marketplace_dev;Password=ChangeMe123!;MultipleActiveResultSets=true;TrustServerCertificate=Yes;App=mantu-nvim-debug"
  local function cs(db)
    return string.format("Server=%s,1433;Database=%s;%s", ip, db, cred)
  end

  vim.env["ConnectionStrings__SMARTAmaris"] = cs("SMART_Amaris")
  vim.env["ConnectionStrings__ERPDocument"] = cs("ERP_Document")
  vim.env["ConnectionStrings__DocumentStaging"] = cs("Document_Staging")
  vim.env["ConnectionStrings__CDN"] = cs("CDN")
  vim.env["ConnectionStrings__ERP_CorporateFiles"] = cs("ERP_CorporateFiles")
end

local dap_pid = require("config.functions").dap_pid
local cs_configs = require("dap").configurations.cs

for _, api in ipairs({
  { label = "needs-api", path = "/Needs/src/Api.Server/" },
  { label = "candidates-api", path = "/Candidates/src/Api.Server/" },
  { label = "joboffers-api", path = "/JobOffers/src/Api.Server/" },
}) do
  table.insert(cs_configs, {
    type = "coreclr",
    name = "attach: " .. api.label .. " (Aspire)",
    request = "attach",
    processId = dap_pid(api.path, api.label),
  })
end
