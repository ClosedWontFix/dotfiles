-- -*- lua -*-
-- vim: ft=lua
--
-- File: ~/.config/nvim/lua/plugins/live-preview.lua
-- Author: Dan Borkowski
--

return {
  {
    'brianhuster/live-preview.nvim',
    dependencies = {
      -- You can choose one of the following pickers
      -- 'nvim-telescope/telescope.nvim',
      -- 'ibhagwan/fzf-lua',
      -- 'echasnovski/mini.pick',
      'folke/snacks.nvim',
    },
  }
}
