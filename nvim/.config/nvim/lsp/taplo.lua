local associations = {}
for _, schema in ipairs(require("schemastore").json.schemas()) do
  for _, glob in ipairs(schema.fileMatch or {}) do
    if glob:match("%.toml$") then
      local regex = glob:gsub("[%.%+%-%(%)%[%]%^%$]", "\\%0"):gsub("%*%*/", "\0"):gsub("%*", "[^/]*"):gsub("%z", "(.*/)?")
      associations[(regex:sub(1, 5) == "(.*/)" and "" or "/") .. regex .. "$"] = schema.url
    end
  end
end

return {
  settings = {
    evenBetterToml = {
      schema = {
        enabled = true,
        catalogs = {},
        associations = associations,
      },
    },
  },
}
