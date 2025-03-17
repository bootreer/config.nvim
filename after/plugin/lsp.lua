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
        { name = "copilot" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
    }, {
        { name = "path" },
    }),
    formatting = {
        fields = { "abbr", "menu", "kind" },
        format = function(entry, item)
            -- Define menu shorthand for different completion sources.
            local menu_icon = {
                nvim_lsp = "NLSP",
                nvim_lua = "NLUA",
                luasnip  = "LSNP",
                buffer   = "BUFF",
                path     = "PATH",
            }
            -- Set the menu "icon" to the shorthand for each completion source.
            item.menu = menu_icon[entry.source.name]

            -- Set the fixed width of the completion menu to 60 characters.
            -- fixed_width = 20

            -- Set 'fixed_width' to false if not provided.
            fixed_width = fixed_width or false

            -- Get the completion entry text shown in the completion window.
            local content = item.abbr

            -- Set the fixed completion window width.
            if fixed_width then
                vim.o.pumwidth = fixed_width
            end

            -- Get the width of the current window.
            local win_width = vim.api.nvim_win_get_width(0)

            -- Set the max content width based on either: 'fixed_width'
            -- or a percentage of the window width, in this case 20%.
            -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
            local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

            -- Truncate the completion entry text if it's longer than the
            -- max content width. We subtract 3 from the max content width
            -- to account for the "..." that will be appended to it.
            if #content > max_content_width then
                item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
            else
                item.abbr = content .. (" "):rep(max_content_width - #content)
            end
            return item
        end,
    },
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
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' },
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
    ts_ls = true,
    tinymist = {
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

-- NOTE
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

local s = luasnip.snippet
local t = luasnip.text_node

luasnip.add_snippets("coq", {
    s("\\fun", { t("λ") }),
    s("\\mult", { t("⋅") }),
    s("\\ent", { t("⊢") }),
    s("\\valid", { t("✓") }),
    s("\\diamond", { t("◇") }),
    s("\\box", { t("□") }),
    s("\\bbox", { t("■") }),
    s("\\later", { t("▷") }),
    s("\\pred", { t("φ") }),
    s("\\and", { t("∧") }),
    s("\\or", { t("∨") }),
    s("\\comp", { t("∘") }),
    s("\\ccomp", { t("◎") }),
    s("\\all", { t("∀") }),
    s("\\ex", { t("∃") }),
    s("\\to", { t("→") }),
    s("\\sep", { t("∗") }),
    s("\\lc", { t("⌜") }),
    s("\\rc", { t("⌝") }),
    s("\\Lc", { t("⎡") }),
    s("\\Rc", { t("⎤") }),
    s("\\lam", { t("λ") }),
    s("\\empty", { t("∅") }),
    s("\\Lam", { t("Λ") }),
    s("\\Sig", { t("Σ") }),
    s("\\-", { t("∖") }),
    s("\\aa", { t("●") }),
    s("\\af", { t("◯") }),
    s("\\auth", { t("●") }),
    s("\\frag", { t("◯") }),
    s("\\iff", { t("↔") }),
    s("\\gname", { t("γ") }),
    s("\\incl", { t("≼") }),
    s("\\latert", { t("▶") }),
    s("\\update", { t("⇝") }),
    s("\\\"o", { t("ö") }),
    s("_a", { t("ₐ") }),
    s("_e", { t("ₑ") }),
    s("_h", { t("ₕ") }),
    s("_i", { t("ᵢ") }),
    s("_k", { t("ₖ") }),
    s("_l", { t("ₗ") }),
    s("_m", { t("ₘ") }),
    s("_n", { t("ₙ") }),
    s("_o", { t("ₒ") }),
    s("_p", { t("ₚ") }),
    s("_r", { t("ᵣ") }),
    s("_s", { t("ₛ") }),
    s("_t", { t("ₜ") }),
    s("_u", { t("ᵤ") }),
    s("_v", { t("ᵥ") }),
    s("_x", { t("ₓ") }),

    -- greek letters --
    s('\\alpha', { t('α') }),
    s('\\beta', { t('β') }),
    s('\\gamma', { t('γ') }),
    s('\\delta', { t('δ') }),
    s('\\epsilon', { t('ε') }),
    s('\\zeta', { t('ζ') }),
    s('\\eta', { t('η') }),
    s('\\theta', { t('θ') }),
    s('\\iota', { t('ι') }),
    s('\\kappa', { t('κ') }),
    s('\\lambda', { t('λ') }),
    s('\\mu', { t('μ') }),
    s('\\nu', { t('ν') }),
    s('\\xi', { t('ξ') }),
    s('\\pi', { t('π') }),
    s('\\rho', { t('ρ') }),
    s('\\sigma', { t('σ') }),
    s('\\tau', { t('τ') }),
    s('\\upsilon', { t('υ') }),
    s('\\phi', { t('φ') }),
    s('\\chi', { t('χ') }),
    s('\\psi', { t('ψ') }),
    s('\\omega', { t('ω') }),
    s('\\Gamma', { t('Γ') }),
    s('\\Delta', { t('Δ') }),
    s('\\Theta', { t('Θ') }),
    s('\\Lambda', { t('Λ') }),
    s('\\Xi', { t('Ξ') }),
    s('\\Pi', { t('Π') }),
    s('\\Sigma', { t('Σ') }),
    s('\\Upsilon', { t('Υ') }),
    s('\\Phi', { t('Φ') }),
    s('\\Psi', { t('Ψ') }),
    s('\\Omega', { t('Ω') }),
}
)
