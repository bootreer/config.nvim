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

    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,

        -- disable = { 'latex' },
    },

    textobjects = {
        select = {
            enable = true,

            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
    },
})

require("treesitter-context").setup({
    -- this breaks quite often with Zig
    -- and is generally not all that useful I find
    enable = false,        -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0,         -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = "outer",  -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = "cursor",       -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20,  -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})
