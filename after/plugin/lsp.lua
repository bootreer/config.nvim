local lspconfig = require("lspconfig")
local cmp = require("cmp")
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
local luasnip = require("luasnip")

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

        -- jumping between snippet positions is on a different keybind
        -- because otherwise it would jump to previous snippet positions
        -- when trying to just write a tab somewhere else

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

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.clangd.setup({
    capabilities = capabilities,
})

lspconfig.ocamllsp.setup({
    capabilities = capabilities,
})

lspconfig.lua_ls.setup({
    capabilities = capabilities,
})

lspconfig.typst_lsp.setup({
    capabilities = capabilities,
    settings = {
        exportPdf = "never",
    },
})

lspconfig.zls.setup({
    capabilities = capabilities,
})

lspconfig.html.setup({
    capabilities = capabilities,
})

lspconfig.tsserver.setup({
    capabilities = capabilities,
})

lspconfig.jsonls.setup({
    capabilities = capabilities,
})

require('isabelle-lsp').setup({
    isabelle_path = '/Users/tuomas/isabelle-lsp/nvim/bin/isabelle',
})

lspconfig.isabelle.setup({
    capabilities = capabilities,
})

local group = vim.api.nvim_create_augroup("clangd_extensions", {
    clear = true,
})

vim.api.nvim_create_autocmd("Filetype", {
    group = group,
    desc = "Setup clangd_extensions scores for cmp",
    pattern = "c,cpp,h,hpp,cc",
    callback = function()
        cmp.setup.buffer({
            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.recently_used,
                    require("clangd_extensions.cmp_scores"),
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
        })
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "Setup clangd_extension keymap for cmp",
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil or client.name ~= "clangd" then
            return
        end
        vim.keymap.set("n", "<localleader>cca", "<cmd>ClangdAST<CR>", { buffer = bufnr, desc = "Show AST" })
        vim.keymap.set(
            "n",
            "<leader>cch",
            "<cmd>ClangdSwitchSourceHeader<CR>",
            { buffer = bufnr, desc = "Switch between source and header" }
        )
        vim.keymap.set(
            "n",
            "<localleader>h",
            "<cmd>ClangdTypeHierarchy<CR>",
            { buffer = bufnr, desc = "Show type hierarchy" }
        )
    end,
})

vim.g.rustaceanvim = {
    inlay_hints = {
        highlight = "NonText",
    },
    tools = {
        hover_actions = {
            auto_focus = true,
        },
    },
    server = {
        on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true }
            vim.api.nvim_buf_set_keymap(
                bufnr,
                "n",
                "s",
                '<cmd>lua require("tree_climber_rust").init_selection()<CR>',
                opts
            )
            vim.api.nvim_buf_set_keymap(
                bufnr,
                "x",
                "s",
                '<cmd>lua require("tree_climber_rust").select_incremental()<CR>',
                opts
            )
            vim.api.nvim_buf_set_keymap(
                bufnr,
                "x",
                "S",
                '<cmd>lua require("tree_climber_rust").select_previous()<CR>',
                opts
            )
            require("lsp-inlayhints").on_attach(client, bufnr)
        end,
    },
}
