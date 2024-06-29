local cmp = require("cmp")
local luasnip = require("luasnip")
local lspconfig = require("lspconfig")
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }

require("mason").setup()

-- setup autocomplete
cmp.setup({
    snippet = {
        expand = function(args)
            -- vim.fn['vsnip#anonymous'](args.body) -- vsnip
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
        end,
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<TAB>"] = cmp.mapping.select_next_item(cmp_select_opts),
        ["<S-TAB>"] = cmp.mapping.select_prev_item(cmp_select_opts),
        ["<ENTER>"] = cmp.mapping.confirm({ select = false }),
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
    preselect = cmp.PreselectMode.Item, -- set to cmp.PreselectMode.None to disable preselect
})

require('isabelle-lsp').setup({
    isabelle_path = '/Users/tuomas/isabelle-lsp/nvim/bin/isabelle',
})

-- idk
-- local c = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
    lua_ls = true,
    jsonls = true,
    html = true,
    typst_lsp = {
        settings = {
            exportPdf = "never",
        }
    },
    tsserver = true,
    isabelle = true,
    ocamllsp = {
        settings = {
            codelens = { enable = true },
            inlayHints = { enable = true },
        },
    },

    clangd = true,
    zls = true,
    -- rust_analyzer = true,
}

for name, config in pairs(servers) do
    if config == true then
        config = {}
    end
    config = vim.tbl_deep_extend("force", {}, {
        capabilities = capabilities,
    }, config)

    lspconfig[name].setup(config)
end

vim.g.rustaceanvim = {
    inlay_hints = {
        highlight = "NonText",
    },
    tools = {
        hover_actions = {
            auto_focus = true,
        },
    },
}
