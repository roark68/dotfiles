require("config")
require("plugins")

local local_config = vim.fn.stdpath("config") .. "/local/init.lua"
if vim.uv.fs_stat(local_config) then
  dofile(local_config)
end
