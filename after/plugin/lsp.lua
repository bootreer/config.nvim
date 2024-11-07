local cmp = require("cmp")
local luasnip = require("luasnip")
local lspconfig = require("lspconfig")
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }

require("mason").setup()

local _border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = _border
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = _border
    }
)

vim.diagnostic.config {
    float = { border = _border }
}

require("lspconfig.ui.windows").default_options = {
    border = _border
}

-- setup autocomplete
cmp.setup({
    snippet = {
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- vsnip
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
            -- require("snippy").expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<TAB>"] = cmp.mapping.select_next_item(cmp_select_opts),
        ["<S-TAB>"] = cmp.mapping.select_prev_item(cmp_select_opts),
        ["<ENTER>"] = cmp.mapping.confirm({ select = false }),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.confirm({ select = true })
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),

        ["<C-l>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" },
    }, {
        { name = "path" },
    }),
    window = {
        completion = { border = _border },
        documentation = { border = _border }
    },
    preselect = cmp.PreselectMode.Item, -- set to cmp.PreselectMode.None to disable preselect
})

require("isabelle-lsp").setup({
    isabelle_path = "/Users/tuomas/isabelle-lsp/isabelle-language-server/bin/isabelle",
    unicode_symbols_output = true,
    unicode_symbols_edits = true,
})

require('ocaml').setup()

-- idk
-- local c = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
    clangd = true,
    html = true,
    gleam = true,
    jsonls = true,
    isabelle = {
        unicode_symbols_output = true,
        unicode_symbols_edits = true,
    },
    lua_ls = true,
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
    ts_ls = true,
    typst_lsp = {
        settings = {
            exportPdf = "never",
        },
    },
    zls = true,
    -- rust_analyzer = true,
}

for name, config in pairs(servers) do
    if config then
        config = {}
    end
    config = vim.tbl_deep_extend("force", {}, {
        capabilities = capabilities,
    }, config)

    lspconfig[name].setup(config)
end


local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
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
