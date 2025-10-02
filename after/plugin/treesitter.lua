require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "asm",
        "bash",
        "c",
        "cpp",
        "lua",
        "rust",
        "markdown",
        "markdown_inline",
        "javascript",
        "typescript",
        "vue",
        "zig",
        "haskell",
        "ocaml",
    },
    sync_install = false,
    modules = {},
    ignore_install = {},
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = { 'latex' },
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-s>",
            node_incremental = "<C-s>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },
})

require("treesitter-context").setup({
    enable = false,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = "outer",
    mode = "cursor",
    separator = nil,
    zindex = 20,
    on_attach = nil,
})
