-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Try to require "config.lazy-lockfile" if it exists, but don’t error if missing
pcall(require, "config.lazy-lockfile")

-- disable format on save everywhere
vim.g.autoformat = false

-- Increase leader-key timeout (default is 1000ms = 1s)
vim.o.timeout = true        -- enable timeouts for mapped sequences
vim.o.timeoutlen = 2000     -- 1.5s (adjust to taste, e.g., 2000 for 2s)
vim.o.ttimeoutlen = 10      -- 10ms for keycodes (fast <Esc> in insert mode)


