local _border = "single"

vim.diagnostic.config {
    float = { border = _border },
    virtual_lines = true,
}

require("lspconfig.ui.windows").default_options = {
    border = _border
}

require("isabelle-lsp").setup({
    isabelle_path = vim.fn.expand('$HOME/isabelle-lsp/isabelle-dev/bin/isabelle'),
    unicode_symbols_output = true,
    unicode_symbols_edits = true,
    vsplit = true,
})

require('ocaml').setup()

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
    svelte = true,
    texlab = true,
    tinymist = {
        settings = {
            exportPdf = "never",
        },
    },
    ts_ls = {
        -- init_options = {
        --     plugins = {
        --         {
        --             name = "@vue/typescript-plugin",
        --             location = "",
        --             languages = { "vue" },
        --         },
        --     },
        -- },
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

    vim.lsp.config[name] = config
    vim.lsp.enable(name)
end

local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.11.2/"
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

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
    dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path)
    }
}
