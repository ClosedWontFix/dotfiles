-- -*- lua -*-
-- vim: ft=lua
--
-- File: ~/.config/nvim/lua/config/autocmds.lua
-- Author: Dan Borkowski
--

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ~/.config/nvim/lua/config/autocmds.lua
-- Auto-insert shebang + modelines for new files, and chmod +x on save

local headers = {
  sh        = { "#!/bin/sh",             "# -*- sh -*-",          "# vim: ft=sh",        "" },
  bash      = { "#!/usr/bin/env bash",   "# -*- bash -*-",        "# vim: ft=bash",      "" },
  zsh       = { "#!/usr/bin/env zsh",    "# -*- zsh -*-",         "# vim: ft=zsh",       "" },
  python    = { "#!/usr/bin/env python3","# -*- python -*-",      "# vim: ft=python",    "" },
  perl      = { "#!/usr/bin/env perl",   "# -*- perl -*-",        "# vim: ft=perl",      "" },
  lua       = {                          "-- -*- lua -*-",        "-- vim: ft=lua",      "" },
  dockerfile= {                          "# -*- dockerfile -*-",  "# vim: ft=dockerfile","" },
  yaml      = {                          "# -*- yaml -*-",        "# vim: ft=yaml",      "" },
  toml      = {                          "# -*- conf-toml -*-",   "# vim: ft=toml",      "" },
  ini       = {                          "# -*- conf -*-",        "# vim: ft=dosini",    "" },
}

local function add_header(patterns, key)
  vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = patterns,
    group = vim.api.nvim_create_augroup("ModelineHeaders_" .. key, { clear = true }),
    callback = function(args)
      -- Only insert if the buffer is empty (avoid duplicating in templated files)
      local line_count = vim.api.nvim_buf_line_count(args.buf)
      local first_line = (vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or "")
      if line_count == 1 and first_line == "" then
        vim.api.nvim_buf_set_lines(args.buf, 0, 0, false, headers[key])
      end
    end,
  })
end

-- Register patterns
add_header({ "*.sh" }, "sh")
add_header({ "*.bash" }, "bash")
add_header({ "*.zsh" }, "zsh")
add_header({ "*.py" }, "python")
add_header({ "*.pl", "*.pm", "*.t" }, "perl")
add_header({ "*.lua" }, "lua")
add_header({ "Dockerfile", "*.Dockerfile" }, "dockerfile")
add_header({ "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" }, "yaml")
add_header({ "*.yml", "*.yaml" }, "yaml")
add_header({ "*.toml" }, "toml")
add_header({ "*.ini", ".editorconfig", ".gitconfig" }, "ini")

-- Make scripts executable on save if they start with a shebang
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("ShebangChmod", { clear = true }),
  callback = function(args)
    if vim.fn.has("unix") == 1 then
      local first = (vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or "")
      if first:match("^#!") then
        local file = vim.api.nvim_buf_get_name(args.buf)
        if file ~= "" then
          vim.fn.system({ "chmod", "u+x", "--", file })
        end
      end
    end
  end,
})

