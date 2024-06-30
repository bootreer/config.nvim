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
    -- colorschemes
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
        "kylechui/nvim-surround",
        version = "*", -- use for stability
        event = "VeryLazy",
        opts = {},
    },
    {
        "tjdevries/colorbuddy.nvim",
    },
    --
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("alpha").setup(require "alpha.themes.startify".config)
        end
    },
    --
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },
    --
    -- {
    --     "folke/noice.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         cmdline = { enabled = false },
    --         messages = { enabled = false },
    --         lsp = {
    --             progress = { enabled = false },
    --         },
    --     },
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --     }
    -- },

    {
        "stevearc/dressing.nvim",
        opts = {},
    },
    --
    "alexghergh/nvim-tmux-navigation",

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
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    -- terminal emulator
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = { --[[ things you want to change go here]]
        },
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
        opts = {},
    },

    -- status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons"
    },

    -- gcc keybind
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },

    -- {
    --     "nvim-neo-tree/neo-tree.nvim",
    --     branch = "v3.x",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    --         "MunifTanjim/nui.nvim",
    --         -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    --     },
    -- },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
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
        "j-hui/fidget.nvim", opts = {}
    },

    "williamboman/mason.nvim",

    {
        "folke/neodev.nvim",
        opts = {},
    },

    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        lazy = false,   -- This plugin is already lazy
    },

    "p00f/clangd_extensions.nvim",

    -- {
    --     "nvimdev/lspsaga.nvim",
    --     event = "LspAttach",
    --     config = function()
    --         require("lspsaga").setup({})
    --     end,
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter", -- optional
    --         "nvim-tree/nvim-web-devicons",     -- optional
    --     }
    -- },

    "Treeniks/isabelle-lsp.nvim",
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
        "lvimuser/lsp-inlayhints.nvim",
        opts = {},
    },

    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            hint_prefix = "",
            floating_window = false,
            bind = true,
        },
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },

    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    },

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
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
        -- opts = {
        --     rocks = { "magick " },
        -- }
    },

    {
        "nvim-neorg/neorg",
        dependencies = { "luarocks.nvim" },
        lazy = false,
        version = "*",
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                notes = "~/notes",
                                fpv = "~/uni/fpv",
                            },
                            default_workspace = "notes",
                        },
                    },
                    ["core.completion"] = {
                        config = {
                            engine = "nvim-cmp",
                            name = "[Neorg]"
                        }
                    },
                    -- ["core.manoeuvre"] = {},
                    ["core.presenter"] = {
                        config = {
                            zen_mode = "zen-mode",
                        }
                    },

                    -- require nvim 0.10
                    -- ["core.integrations.image"] = {},
                    -- ["core.latex.renderer"] = {},
                    -- ["core.ui.calendar"] = {},
                }
            }

            vim.wo.foldlevel = 99
            vim.wo.conceallevel = 2
        end
    },

    -- {
    --     "3rd/image.nvim",
    --     dependencies = { "luarocks.nvim" },
    --     config = function()
    --         require("image").setup({
    --             backend = "ueberzug"
    --         })
    --     end
    -- },

    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup {}
        end
    },

})
