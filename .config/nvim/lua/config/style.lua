-- -*- lua -*-
-- vim: ft=lua
--
-- File: ~/.config/nvim/lua/config/style.lua
-- Author: Dan Borkowski
--

-- ---------- Core style defaults ----------
vim.opt.encoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.textwidth = 0
vim.opt.fixendofline = false
vim.opt.list = true
vim.opt.listchars = { tab = "»·", trail = "·", extends = "…", precedes = "…" }

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    if vim.bo.modifiable then
      local save = vim.fn.winsaveview()
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.winrestview(save)
    end
  end,
})

-- ---------- Filetype-specific indentation ----------
local ft = vim.api.nvim_create_augroup("IndentByFiletype", { clear = true })
local set_indent = function(sw, et)
  return function()
    vim.bo.shiftwidth = sw
    vim.bo.tabstop = sw
    vim.bo.softtabstop = sw
    vim.bo.expandtab = et
  end
end

vim.api.nvim_create_autocmd("FileType", { pattern = { "python" }, callback = set_indent(4, true), group = ft })
vim.api.nvim_create_autocmd("FileType", { pattern = { "make" },   callback = function()
  vim.bo.expandtab = false; vim.bo.shiftwidth = 8; vim.bo.tabstop = 8; vim.bo.softtabstop = 0
end, group = ft })
vim.api.nvim_create_autocmd("FileType", { pattern = { "yaml" },   callback = set_indent(2, true), group = ft })
vim.api.nvim_create_autocmd("FileType", { pattern = { "toml","lua" }, callback = set_indent(2, true), group = ft })
vim.api.nvim_create_autocmd("FileType", { pattern = { "json","jsonc" }, callback = set_indent(2, true), group = ft })
vim.api.nvim_create_autocmd("FileType", { pattern = { "dockerfile" }, callback = set_indent(4, true), group = ft })
vim.api.nvim_create_autocmd("FileType", { pattern = { "sh","bash","zsh" }, callback = set_indent(2, true), group = ft })
vim.api.nvim_create_autocmd("FileType", { pattern = { "perl" }, callback = set_indent(4, true), group = ft })
vim.api.nvim_create_autocmd("FileType", { pattern = { "gitignore","conf","tmux" }, callback = set_indent(2, true), group = ft })

-- ---------- Extra filetype detection ----------
local ftd = vim.api.nvim_create_augroup("ExtraFtDetect", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { ".tmux.conf", "*.tmux" }, command = "setf tmux", group = ftd })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "lynx.cfg", ".lynx.cfg" }, command = "setf conf", group = ftd })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { ".gitignore", "*.ignore" }, command = "setf gitignore", group = ftd })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "Dockerfile*", "*.dockerfile" }, command = "setf dockerfile", group = ftd })

