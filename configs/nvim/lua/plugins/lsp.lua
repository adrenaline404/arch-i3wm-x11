return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { 
                    "pyright",       -- Python
                    "rust_analyzer", -- Rust
                    "bashls",        -- Bash
                    "html",          -- HTML
                    "cssls",         -- CSS
                    "lua_ls"         -- Lua
                }, 
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            lspconfig.pyright.setup({ capabilities = capabilities })
            lspconfig.rust_analyzer.setup({ capabilities = capabilities })
            lspconfig.bashls.setup({ capabilities = capabilities })
            lspconfig.html.setup({ capabilities = capabilities })
            lspconfig.cssls.setup({ capabilities = capabilities })
            lspconfig.lua_ls.setup({ capabilities = capabilities })
        end
    }
}