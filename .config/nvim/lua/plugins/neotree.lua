-- -*- lua -*-
-- vim: ft=lua

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      follow_current_file = {
        enabled = true
      },
      window = {
        mappings = {
          ["t"] = "open_tabnew",           -- default
          ["<leader>to"] = "open_tabnew",  -- custom leader key in Neo-tree
        },
      },
    },
  },
}


