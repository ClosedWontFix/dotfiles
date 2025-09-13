-- -*- lua -*-
-- vim: ft=lua

--[[
  Configure LazyVim to use a per-host lockfile instead of the default lazy-lock.json.
  This avoids conflicts when the same dotfiles repo is shared across multiple machines.
  The lockfile name is derived from the system hostname (e.g., lazy-lock-myhost.json).
  Safe to ignore if not present — main config falls back to default behavior.
]]

-- Try to get the hostname in a cross-platform way
local ok, uv = pcall(require, "vim.loop")
local host = "unknown"

if ok and uv.os_gethostname then
  host = uv.os_gethostname():lower()
elseif vim.fn.hostname then
  host = vim.fn.hostname():lower()
end

-- Strip domain if present (get short hostname)
host = host:gsub("%..*$", "")

-- Build lockfile path
local lockfile = vim.fn.stdpath("config") .. "/lazy-lock-" .. host .. ".json"

-- Tell Lazy.nvim to use it (if Lazy is already loaded)
pcall(function()
  require("lazy.core.config").options.lockfile = lockfile
end)

-- Export globally for later (if Lazy loads after this file)
vim.g.lazy_custom_lockfile = lockfile

