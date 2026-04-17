return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua", -- optional
    "echasnovski/mini.pick", -- optional
    "folke/snacks.nvim", -- optional
  },
  config = function()
    local neogit = require "neogit"
    vim.keymap.set("n", "<leader>gi", neogit.open, {})
    vim.keymap.set("n", "<leader>gl", function()
      neogit.open { "log" }
    end, {
      noremap = true,
      silent = true,
      desc = "Neogit Log",
    })
    vim.keymap.set("n", "<leader>gp", function()
      neogit.open({ "pull" })
    end, {})
    vim.keymap.set("n", "<leader>gd", function ()
      neogit.open({ "diff" })
    end, {})
    vim.keymap.set("n", "<leader>gb", function()
      neogit.open({ "branch" })
    end, {})
    vim.keymap.set("n", "<leader>gr", function()
        neogit.open({ "rebase" })
    end, {})
    vim.keymap.set("n", "<leader>gP", function()
      neogit.open({ "push" })
    end, {})
    vim.keymap.set("n", "<leader>gs", function()
      neogit.open({ "stash" })
    end, {})
    vim.keymap.set("n", "<leader>gc", function()
      neogit.open({ "cherrypick" })
    end, {})
    vim.keymap.set("n", "<leader>gt", function()
      neogit.open({ "tag" })
    end, {})

  end,
}
