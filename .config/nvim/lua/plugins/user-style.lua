-- -*- lua -*-
-- vim: ft=lua
--
-- File: ~/.config/nvim/lua/plugins/user-style.lua
-- Author: Dan Borkowski
--

-- Load user style settings early
return {
  {
    "LazyVim/LazyVim",
    priority = 1000,
    init = function()
      require("config.style")
    end,
  },
}



