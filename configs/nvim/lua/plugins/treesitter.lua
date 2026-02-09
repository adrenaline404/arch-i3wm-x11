return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "python", "rust", "bash", "html", "css", "lua", "vim" },
            auto_install = true,
            highlight = { enable = true },
        })
    end,
}