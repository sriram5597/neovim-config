return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
     dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls"},
        automatic_enable = false
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspConfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      lspConfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspConfig.ts_ls.setup({
        capabilities = capabilities
      })
      lspConfig.pyright.setup({
        capabilities = capabilities
      })
      lspConfig.ruff.setup({
        capabilities = capabilities
      })
      lspConfig.tailwindcss.setup({
        capabilities = capabilities
      })
      lspConfig.cssls.setup({
        capabilities = capabilities
      })
      lspConfig.html.setup({
        capabilities = capabilities
      })
    end
  }
}
