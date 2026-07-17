return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install({
      "lua", "javascript", "css", "html", "c", "python",
      "dockerfile", "typescript", "go", "bash",
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua", "javascript", "css", "html", "c", "python",
        "dockerfile", "typescript", "go", "bash", "markdown",
      },
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
}
