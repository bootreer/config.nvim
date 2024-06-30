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
    isabelle_path = "/Users/tuomas/isabelle-lsp/nvim/bin/isabelle",
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

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local function copy(args)
    return args[1]
end

luasnip.add_snippets('isabelle', {
    -- ===== custom =====
    s('\\Implies', { t('⟹') }),
    s('\\implies', { t('⟶') }),
    s('\\To', { t('⇒') }),
    s('\\to', { t('→') }),
    s('\\Iff', { t('⟺') }),
    s('\\iff', { t('⟷') }),

    -- lattice shit
    s('\\glb', { t('⊓') }),
    s('\\Glb', { t('⨅') }),
    s('\\lub', { t('⊔') }),
    s('\\Lub', { t('⨆') }),

    s('\\meet', { t('⊓') }),
    s('\\Meet', { t('⨅') }),
    s('\\join', { t('⊔') }),
    s('\\Join', { t('⨆') }),

    s('\\tree', { t('⟨'), i(1), t('⟩') }),
    s('\\leaf', { t('⟨⟩') }),

    -- numbers
    s('\\sub', { t('\\<^sub>') }),
    s('\\bsub', { t('\\<^bsub>') }),
    s('\\esub', { t('\\<^esub>') }),

    s('\\sup', { t('\\<^sup>') }),
    s('\\bsup', { t('\\<^bsup>') }),
    s('\\esup', { t('\\<^esup>') }),

    -- isabelle keywords
    s('simp', { t('simp') }),
    s('auto', { t('auto') }),
    s('force', { t('force') }),
    s('fastforce', { t('fastforce') }),
    s('blast', { t('blast') }),
    s('try0', { t('try0') }),
    s('sledgehammer', { t('sledgehammer') }),

    s('\\comment', {
        t('― ‹'),
        i(1),
        t('›')
    }),

    s('fun', {
        t('fun '),
        i(1),
        t(' :: "'),
        i(2),
        t({ '" where', '\t"' }),
        f(copy, 1),
        t(' '),
        i(3, '_'),
        t(' = '),
        i(4, 'undefined'),
        t('"'),
    }),
    s('inductive', {
        t('inductive '),
        i(1),
        t(' :: "'),
        i(2),
        t({ '" where', '\t"' }),
        i(3),
        t('"'),
    }),
    s('proof', {
        t('proof ('),
        i(1, 'induction'),
        t({ ')', '\t' }),
        i(2),
        t({ '', 'qed' }),
    }),

    -- ===== all other symbols ig =====
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

    s('\\complex', { t('ℂ') }),
    s('\\rat', { t('ℚ') }),
    s('\\real', { t('ℝ') }),
    s('\\int', { t('ℤ') }),

    s('\\leftarrow', { t('←') }),
    s('\\longleftarrow', { t('⟵') }),
    s('\\longlongleftarrow', { t('⤎') }),
    s('\\longlonglongleftarrow', { t('⇠') }),
    s('\\rightarrow', { t('→') }),
    s('\\longrightarrow', { t('⟶') }),
    s('\\longlongrightarrow', { t('⤏') }),
    s('\\longlonglongrightarrow', { t('⇢') }),
    s('\\Leftarrow', { t('⇐') }),
    s('\\Longleftarrow', { t('⟸') }),
    s('\\Lleftarrow', { t('⇚') }),
    s('\\Rightarrow', { t('⇒') }),
    s('\\Longrightarrow', { t('⟹') }),
    s('\\Rrightarrow', { t('⇛') }),
    s('\\leftrightarrow', { t('↔') }),
    s('\\longleftrightarrow', { t('⟷') }),
    s('\\Leftrightarrow', { t('⇔') }),
    s('\\Longleftrightarrow', { t('⟺') }),
    s('\\mapsto', { t('↦') }),
    s('\\longmapsto', { t('⟼') }),
    s('\\midarrow', { t('─') }),
    s('\\Midarrow', { t('═') }),
    s('\\hookleftarrow', { t('↩') }),
    s('\\hookrightarrow', { t('↪') }),
    s('\\leftharpoondown', { t('↽') }),
    s('\\rightharpoondown', { t('⇁') }),
    s('\\leftharpoonup', { t('↼') }),
    s('\\rightharpoonup', { t('⇀') }),
    s('\\rightleftharpoons', { t('⇌') }),
    s('\\leadsto', { t('↝') }),
    s('\\downharpoonleft', { t('⇃') }),
    s('\\downharpoonright', { t('⇂') }),
    s('\\upharpoonleft', { t('↿') }),
    s('\\restriction', { t('↾') }),
    s('\\Colon', { t('∷') }),
    s('\\up', { t('↑') }),
    s('\\Up', { t('⇑') }),
    s('\\down', { t('↓') }),
    s('\\Down', { t('⇓') }),
    s('\\updown', { t('↕') }),
    s('\\Updown', { t('⇕') }),
    s('\\langle', { t('⟨') }),
    s('\\rangle', { t('⟩') }),
    s('\\llangle', { t('⟪') }),
    s('\\rrangle', { t('⟫') }),
    s('\\lceil', { t('⌈') }),
    s('\\rceil', { t('⌉') }),
    s('\\lfloor', { t('⌊') }),
    s('\\rfloor', { t('⌋') }),
    s('\\lparr', { t('⦇') }),
    s('\\rparr', { t('⦈') }),
    s('\\lbrakk', { t('⟦') }),
    s('\\rbrakk', { t('⟧') }),
    s('\\lbrace', { t('⦃') }),
    s('\\rbrace', { t('⦄') }),
    s('\\lblot', { t('⦉') }),
    s('\\rblot', { t('⦊') }),
    s('\\guillemotleft', { t('«') }),
    s('\\guillemotright', { t('»') }),
    s('\\bottom', { t('⊥') }),
    s('\\top', { t('⊤') }),
    s('\\and', { t('∧') }),
    s('\\And', { t('⋀') }),
    s('\\or', { t('∨') }),
    s('\\Or', { t('⋁') }),
    s('\\forall', { t('∀') }),
    s('\\exists', { t('∃') }),
    s('\\nexists', { t('∄') }),
    s('\\not', { t('¬') }),
    s('\\circle', { t('○') }),
    s('\\box', { t('□') }),
    s('\\diamond', { t('◇') }),
    s('\\diamondop', { t('⋄') }),
    s('\\turnstile', { t('⊢') }),
    s('\\Turnstile', { t('⊨') }),
    s('\\tturnstile', { t('⊩') }),
    s('\\TTurnstile', { t('⊫') }),
    s('\\stileturn', { t('⊣') }),
    s('\\surd', { t('√') }),
    s('\\le', { t('≤') }),
    s('\\ge', { t('≥') }),
    s('\\lless', { t('≪') }),
    s('\\ggreater', { t('≫') }),
    s('\\lesssim', { t('≲') }),
    s('\\greatersim', { t('≳') }),
    s('\\lessapprox', { t('⪅') }),
    s('\\greaterapprox', { t('⪆') }),
    s('\\in', { t('∈') }),
    s('\\notin', { t('∉') }),
    s('\\subset', { t('⊂') }),
    s('\\supset', { t('⊃') }),
    s('\\subseteq', { t('⊆') }),
    s('\\supseteq', { t('⊇') }),
    s('\\sqsubset', { t('⊏') }),
    s('\\sqsupset', { t('⊐') }),
    s('\\sqsubseteq', { t('⊑') }),
    s('\\sqsupseteq', { t('⊒') }),
    s('\\inter', { t('∩') }),
    s('\\Inter', { t('⋂') }),
    s('\\union', { t('∪') }),
    s('\\Union', { t('⋃') }),
    s('\\squnion', { t('⊔') }),
    s('\\Squnion', { t('⨆') }),
    s('\\sqinter', { t('⊓') }),
    s('\\Sqinter', { t('⨅') }),
    s('\\setminus', { t('∖') }),
    s('\\propto', { t('∝') }),
    s('\\uplus', { t('⊎') }),
    s('\\Uplus', { t('⨄') }),
    s('\\noteq', { t('≠') }),
    s('\\sim', { t('∼') }),
    s('\\doteq', { t('≐') }),
    s('\\simeq', { t('≃') }),
    s('\\approx', { t('≈') }),
    s('\\asymp', { t('≍') }),
    s('\\cong', { t('≅') }),
    s('\\smile', { t('⌣') }),
    s('\\equiv', { t('≡') }),
    s('\\frown', { t('⌢') }),
    s('\\Join', { t('⋈') }),
    s('\\bowtie', { t('⨝') }),
    s('\\prec', { t('≺') }),
    s('\\succ', { t('≻') }),
    s('\\preceq', { t('≼') }),
    s('\\succeq', { t('≽') }),
    s('\\parallel', { t('∥') }),
    s('\\Parallel', { t('‖') }),
    s('\\interleave', { t('⫴') }),
    s('\\sslash', { t('⫽') }),
    s('\\bar', { t('¦') }),
    s('\\bbar', { t('⫿') }),
    s('\\plusminus', { t('±') }),
    s('\\minusplus', { t('∓') }),
    s('\\times', { t('×') }),
    s('\\div', { t('÷') }),
    s('\\cdot', { t('⋅') }),
    s('\\star', { t('⋆') }),
    s('\\bullet', { t('∙') }),
    s('\\circ', { t('∘') }),
    s('\\dagger', { t('†') }),
    s('\\ddagger', { t('‡') }),
    s('\\lhd', { t('⊲') }),
    s('\\rhd', { t('⊳') }),
    s('\\unlhd', { t('⊴') }),
    s('\\unrhd', { t('⊵') }),
    s('\\triangleleft', { t('◃') }),
    s('\\triangleright', { t('▹') }),
    s('\\triangle', { t('△') }),
    s('\\triangleq', { t('≜') }),
    s('\\oplus', { t('⊕') }),
    s('\\Oplus', { t('⨁') }),
    s('\\otimes', { t('⊗') }),
    s('\\Otimes', { t('⨂') }),
    s('\\odot', { t('⊙') }),
    s('\\Odot', { t('⨀') }),
    s('\\ominus', { t('⊖') }),
    s('\\oslash', { t('⊘') }),
    s('\\dots', { t('…') }),
    s('\\cdots', { t('⋯') }),
    s('\\Sum', { t('∑') }),
    s('\\Prod', { t('∏') }),
    s('\\Coprod', { t('∐') }),
    s('\\infinity', { t('∞') }),
    s('\\integral', { t('∫') }),
    s('\\ointegral', { t('∮') }),
    s('\\clubsuit', { t('♣') }),
    s('\\diamondsuit', { t('♢') }),
    s('\\heartsuit', { t('♡') }),
    s('\\spadesuit', { t('♠') }),
    s('\\aleph', { t('ℵ') }),
    s('\\emptyset', { t('∅') }),
    s('\\nabla', { t('∇') }),
    s('\\partial', { t('∂') }),
    s('\\flat', { t('♭') }),
    s('\\natural', { t('♮') }),
    s('\\sharp', { t('♯') }),
    s('\\angle', { t('∠') }),
    s('\\copyright', { t('©') }),
    s('\\registered', { t('®') }),
    s('\\hyphen', { t('‐') }),
    s('\\inverse', { t('¯') }),
    s('\\sqdot', { t('·') }),
    s('\\onequarter', { t('¼') }),
    s('\\onehalf', { t('½') }),
    s('\\threequarters', { t('¾') }),
    s('\\ordfeminine', { t('ª') }),
    s('\\ordmasculine', { t('º') }),
    s('\\section', { t('§') }),
    s('\\paragraph', { t('¶') }),
    s('\\exclamdown', { t('¡') }),
    s('\\questiondown', { t('¿') }),
    s('\\euro', { t('€') }),
    s('\\pounds', { t('£') }),
    s('\\yen', { t('¥') }),
    s('\\cent', { t('¢') }),
    s('\\currency', { t('¤') }),
    s('\\degree', { t('°') }),
    s('\\amalg', { t('⨿') }),
    s('\\mho', { t('℧') }),
    s('\\lozenge', { t('◊') }),
    s('\\wp', { t('℘') }),
    s('\\wrong', { t('≀') }),
    s('\\acute', { t('´') }),
    s('\\index', { t('ı') }),
    s('\\dieresis', { t('¨') }),
    s('\\cedilla', { t('¸') }),
    s('\\hungarumlaut', { t('˝') }),
    s('\\bind', { t('⤜') }),
    s('\\then', { t('⪢') }),
    s('\\some', { t('ϵ') }),

    s('\\hole', { t('⌑') }),
    s('\\newline', { t('⏎') }),
    -- s('\\comment', { t('―') }),
    s('\\cancel', { t('⌦') }),
    s('\\marker', { t('✐') }),
    s('\\checkmark', { t('✓') }),
    s('\\crossmark', { t('✗') }),
    s('\\open', { t('‹') }),
    s('\\close', { t('›') }),
    s('\\here', { t('⌂') }),
    s('\\undefined', { t('❖') }),
    s('\\noindent', { t('⇤') }),
    s('\\smallskip', { t('┈') }),
    s('\\medskip', { t('┉') }),
    s('\\bigskip', { t('━') }),
    s('\\item', { t('▪') }),
    s('\\enum', { t('▸') }),
    s('\\descr', { t('➧') }),
    s('\\footnote', { t('⁋') }),
    s('\\verbatim', { t('▩') }),
    s('\\theory_text', { t('⬚') }),
    s('\\emph', { t('∗') }),
    s('\\bold', { t('❙') }),
    s('\\sub', { t('⇩') }),
    s('\\sup', { t('⇧') }),
    s('\\bsub', { t('⇘') }),
    s('\\esub', { t('⇙') }),
    s('\\bsup', { t('⇗') }),
    s('\\esup', { t('⇖') }),
    s('\\file', { t('🗏') }),
    s('\\dir', { t('🗀') }),
    s('\\url', { t('🌐') }),
    s('\\doc', { t('📓') }),
    s('\\action', { t('☛') }),
})
