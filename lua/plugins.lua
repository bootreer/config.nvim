-- vi: foldmethod=marker

-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- cosmetics
    -- {{{
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        opts = {}
    },
    {
        "sainnhe/gruvbox-material",
        priority = 1000,
        opts = {}
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("alpha").setup(require "alpha.themes.theta".config)
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bufdelete = { enabled = true },
            input = { enabled = true },
            notifier = { enabled = true },
            scope = { enabled = true },
            words = { enabled = true },
        },
    },
    -- }}}
    --
    {
        "kylechui/nvim-surround",
        version = "*", -- use for stability
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    {
        "backdround/improved-ft.nvim",
        config = function()
            require("improved-ft").setup({
                use_default_mappings = true,
                ignore_char_case = true,
                use_relative_repetition = true,
                use_relative_repetition_offsets = true,
            })
        end
    },

    {
        "aserowy/tmux.nvim",
        config = function()
            return require("tmux").setup()
        end
    },

    "nvim-lua/plenary.nvim",

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-project.nvim",
        },
        opts = {
            pickers = {
                find_files = {
                    follow = true,
                },
            },
        },
        config = function()
            require("telescope").setup {
                -- pickers = {
                --     find_files = {
                --         theme = "dropdown",
                --     }
                -- },
                extensions = {
                    wrap_results = true,
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({})
                    }
                }

            }
            require("telescope").load_extension("project")
            require("telescope").load_extension("ui-select")
        end
    },

    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                columns = { "icon" },
                keymaps = {
                    ["<M-h>"] = "actions.select_split",
                },
                view_options = {
                    show_hidden = true,
                },
            })
        end,
    },

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- Diff integration
            "nvim-telescope/telescope.nvim",
        },
        config = true,
    },

    {
        "FabijanZulj/blame.nvim",
        lazy = false,
        config = function()
            require('blame').setup {}
        end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    -- terminal emulator
    {
        "akinsho/toggleterm.nvim",
        version = "*",
    },

    -- indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { highlight = "Comment", char = "▏" },
            scope = { enabled = false },
        },
    },

    -- whitespace
    {
        "johnfrankmorgan/whitespace.nvim",
        main = "whitespace-nvim",
        config = function()
            require('whitespace-nvim').setup({
                ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard', 'isabelle_output' },
                ignore_terminal = true,
                return_cursor = true,
            })
        end,
    },

    -- status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- gcc keybind
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    {
        "mfussenegger/nvim-treehopper",
        config = function()
            require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }
        end
    },

    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-textobjects",

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local autopairs = require("nvim-autopairs")
            autopairs.setup()
            autopairs.remove_rule("`")
            autopairs.remove_rule("'")
        end,
    },

    -- LSP and autocompletion
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    -- snippet engine (required for nvim-cmp)
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    {
        "m-demare/hlargs.nvim",
        config = function()
            require("hlargs").setup()
        end
    },

    "j-hui/fidget.nvim",
    "williamboman/mason.nvim",

    {
        "folke/lazydev.nvim",
        opts = {
            enabled = function(root_dir)
                return not vim.loop.fs_stat(root_dir .. "/.luarc.json")
            end,
        }
    },

    {
        "tjdevries/ocaml.nvim",
        build = ":lua require(\"ocaml\").update()",
        commit = "8735069ce4267940e1038c7a2942881cf15481ce"
    },

    {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        lazy = false,   -- This plugin is already lazy
    },

    "https://git.sr.ht/~p00f/clangd_extensions.nvim",
    "rhysd/vim-llvm",

    {
        "Treeniks/isabelle-lsp.nvim",
        branch = "isabelle-language-server",
        dependencies = {
            "neovim/nvim-lspconfig"
        }
    },

    "Treeniks/isabelle-syn.nvim",

    -- DAP
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "williamboman/mason.nvim",
        },
    },

    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            hint_prefix = "",
            floating_window = false,
            bind = true,
            handler_opts = {
                border = "single",
            }
        },
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },

    {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        event = "LspAttach",
        config = function()
            require('tiny-code-action').setup()
        end
    },

    -- {
    --     "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --     config = function()
    --         require("lsp_lines").setup()
    --     end,
    -- },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
        }
    },

    {
        "Pocco81/true-zen.nvim",
        config = function()
            require("true-zen").setup {}
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },

    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end
    },

    {
        'nacro90/numb.nvim',
        config = function()
            require('numb').setup()
        end,
    }

})
