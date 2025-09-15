-- -*- lua -*-
-- vim: ft=lua
--
-- File: ~/.config/nvim/lua/config/keymaps.lua
-- Author: Dan Borkowski
--

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ========================
-- Tab management (leader + t)
-- ========================

-- New / open
vim.keymap.set("n", "<leader>te", "<cmd>tabnew<cr>", { desc = "New empty tab" })
vim.keymap.set("n", "<leader>ts", "<cmd>tab split<cr>", { desc = "Open current buffer in new tab" })
vim.keymap.set("n", "<leader>to", "<cmd>tabedit <cfile><cr>", { desc = "Open file under cursor in new tab" })

-- Navigate
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

-- Navigate (vi-style: h=left, l=right)
vim.keymap.set("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Next tab" })

-- Close / only
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tO", "<cmd>tabonly<cr>", { desc = "Close other tabs" })

-- Reordering
vim.keymap.set("n", "<leader>t<Left>", "<cmd>tabmove -1<cr>", { desc = "Move tab left" })
vim.keymap.set("n", "<leader>t<Right>", "<cmd>tabmove +1<cr>", { desc = "Move tab right" })

-- ========================
-- Buffer management (leader + b)
-- ========================

-- New buffer
vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New empty buffer" })

-- Navigate
vim.keymap.set("n", "<leader>bo", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Close / only
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete current buffer" })
vim.keymap.set("n", "<leader>bO", "<cmd>%bd|e#|bd#<cr>", { desc = "Close other buffers" })

-- Alternate / list
vim.keymap.set("n", "<leader>bb", "<cmd>buffer #<cr>", { desc = "Alternate buffer" })
-- If you use Telescope (LazyVim default):
vim.keymap.set("n", "<leader>bl", "<cmd>Telescope buffers<cr>", { desc = "List buffers" })
-- If you prefer builtin :ls, use this instead:
-- vim.keymap.set("n", "<leader>bl", "<cmd>ls<cr>", { desc = "List buffers" })

-- ========================
-- Split management (leader + s)
-- ========================

-- Open a vertical split with a new empty buffer
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })

-- Open a horizontal split with a new empty buffer
vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Split current buffer into a vertical split
vim.keymap.set("n", "<leader>sV", "<cmd>vsplit %<cr>", { desc = "Vertical split of current file" })

-- Split current buffer into a horizontal split
vim.keymap.set("n", "<leader>sH", "<cmd>split %<cr>", { desc = "Horizontal split of current file" })

