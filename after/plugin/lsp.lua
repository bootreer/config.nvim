local _border = "rounded"

vim.diagnostic.config {
    float = { border = _border },
    virtual_lines = true,
}

require("lspconfig.ui.windows").default_options = {
    border = _border
}

local servers = {
    clangd = true,
    html = true,
    gleam = true,
    jsonls = true,
    isabelle = true,
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    disable = { 'missing-fields' },
                },
            },
        },
    },
    nil_ls = {
        settings = {
            ["nil"] = {
                formatting = {
                    command = { "nixfmt" },
                },
            },
        },
    },
    ocamllsp = {
        settings = {
            codelens = { enable = true },
            inlayHints = { enable = true },
        },
        get_language_id = function(_, ftype)
            return ftype
        end,
    },
    pyrefly = {
        enabled = true,
    },
    pyright = {
        enabled = false,
        settings = {
            pyright = {
                disableOrganizeImports = true,
            },
            python = {
                analysis = {
                    ignore = { '*' },
                },
            },
        },
    },
    ols = true,
    ruff = true,
    svelte = true,
    texlab = true,
    tinymist = {
        settings = {
            exportPdf = "never",
        },
    },
    ts_ls = {
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' },
    },
    vue_ls = true,
    zls = true,
}

local capabilities = require('blink.cmp').get_lsp_capabilities()
for name, config in pairs(servers) do
    if config == true then
        config = {}
    end
    config = vim.tbl_deep_extend("force", {}, {
        capabilities = capabilities
    }, config)

    vim.lsp.config(name, config)

    if config.enabled == nil or config.enabled then
        vim.lsp.enable(name)
    end
end

vim.g.rustaceanvim = {
    inlay_hints = {
        highlight = "NonText",
    },
    tools = {
        float_win_config = {
            border = _border,
        },
        hover_actions = {
            auto_focus = true,
        },
    },
}
