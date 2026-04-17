return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      local neoTree = require('neo-tree')
      neoTree.setup({
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true
        }
      }
    })
      vim.keymap.set('n', '<C-b>', ":Neotree filesystem reveal left<CR>")
      vim.keymap.set('n', '<C-e>', ":Neotree close<CR>")
    end
}
