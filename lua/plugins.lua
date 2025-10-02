-- vi: foldmethod=marker

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
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { highlight = "Comment", char = "▏" },
            scope = { enabled = false },
        },
    },
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
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- }}}

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
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = {
                        prompt_position = "top",
                        preview_height = 0.6,
                    },
                },
                pickers = {
                    buffers = {
                        show_all_buffers = true,
                        sort_lastused = true,
                        mappings = {
                            i = {
                                ["<c-d>"] = "delete_buffer",
                            }
                        }
                    },
                },
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
                    ["<C-x>"] = "actions.select_split",
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
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
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
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    jump_labels = true
                }
            },
        },
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },

    "nvim-treesitter/nvim-treesitter-context",

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

    {
        "nvim-zh/colorful-winsep.nvim",
        config = {
            highlight = "#d79921",
            animate = {
                enabled = false
            }
        },
        event = { "WinLeave" },
    },

    -- LSP and autocompletion
    -- {{{
    "neovim/nvim-lspconfig",

    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        opts = {
            keymap = { preset = 'enter' },
            appearance = {
                nerd_font_variant = 'mono'
            },
            completion = { documentation = { auto_show = true } },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = { enabled = true },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
        },
        opts_extend = { "sources.default" }
    },

    {
        "m-demare/hlargs.nvim",
        config = function()
            require("hlargs").setup()
        end
    },

    "j-hui/fidget.nvim",

    {
        "williamboman/mason.nvim",
        opts = {}
    },

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
        version = "^6",
        lazy = false,
    },

    "ziglang/zig.vim",
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

    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        build = function() require "typst-preview".update() end,
    },

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
        opts = {},
    },

    {
        "lervag/vimtex",
        lazy = false,
        init = function() end,
    },

    -- }}}

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
        'nacro90/numb.nvim',
        config = function()
            require('numb').setup()
        end,
    }

})
