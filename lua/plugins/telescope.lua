return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope_builtin = require("telescope.builtin")
      vim.keymap.set('n', '<C-p>', telescope_builtin.find_files, {})
      vim.keymap.set('n', '<C-f>', telescope_builtin.live_grep, {})
    end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").setup {
        defaults = {
          preview = {
            treesitter = false,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            -- even more opts
            }
          },
          ["projects"] = {
          }
        }
      }
      require("telescope").load_extension("ui-select")
    end
  }
}

