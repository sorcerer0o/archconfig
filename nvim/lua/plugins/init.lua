return {
    -- Colorscheme: Modern, low-contrast, optimized for OLED/IPS ThinkPad screens
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

    -- Native Syntax Parser (Tree-sitter)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            -- Modern Fix: Call setup directly on main module
            require("nvim-treesitter").setup({
                ensure_installed = { 
                    "c", "cpp", "lua", "vim", "vimdoc", 
                    "javascript", "typescript", "tsx", 
                    "html", "css", "dockerfile", "json", "yaml" 
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- 2026 Native LSP Configuration Workflow (No require('lspconfig') framework warnings)
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Establish capabilities handshake with nvim-cmp
            local capabilities = {}
            local status, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            if status then
                capabilities = cmp_lsp.default_capabilities()
            else
                capabilities = vim.lsp.protocol.make_client_capabilities()
            end

            -- 1. C/C++ (clangd)
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                },
            })

            -- 2. Full-Stack JavaScript/TypeScript (ts_ls)
            vim.lsp.config("ts_ls", { capabilities = capabilities })

            -- 3. Web & Devops infrastructure
            local infrastructure_servers = { "html", "cssls", "dockerls", "jsonls" }
            for _, server in ipairs(infrastructure_servers) do
                vim.lsp.config(server, { capabilities = capabilities })
            end

            -- Automatically enable all declared configurations via modern API
            vim.lsp.enable({ "clangd", "ts_ls", "html", "cssls", "dockerls", "jsonls" })
        end,
    },

    -- Modern Blazing-Fast Completion Engine
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },

    -- Native-like Fuzzy Finder (Telescope)
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Global Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "List Active Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    vimgrep_arguments = {
                        "rg", "--color=never", "--no-heading", 
                        "--with-filename", "--line-number", 
                        "--column", "--smart-case"
                    },
                }
            })
        end,
    },

    -- Lightweight Smart Delimiters
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
}
