vim.g.mapleader = " "
vim.g.maplocalleader = ";"

local set = vim.keymap.set

-- move highlighted lines up/down
set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

set("n", "J", "mzJ`z")
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("n", ":bd", ":bp | sp | bn | bd", { desc = "Close buffer" })

set("x", "<leader>p", [["_dP]])

-- yank to clipboard
set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
set("n", "<leader>Y", [["+Y]], { desc = "Yank to clipboard" })

set({ "n", "v" }, "<leader>d", [["d]])

set("i", "<C-c>", "<Esc>")

-- TAB to change buffers
set("n", "<TAB>", ":bnext<CR>", { silent = true })
set("n", "<S-TAB>", ":bprevious<CR>", { silent = true })

-- Better tabbing
set("v", "<", "<gv")
set("v", ">", ">gv")

-- control size of splits
set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")
set("n", "<M-t>", "<C-w>+")
set("n", "<M-s>", "<C-w>-")

-- tmux navigation
local nvim_tmux_nav = require("nvim-tmux-navigation")
set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

local builtin = require("telescope.builtin")
set('n', '<leader>ff', builtin.find_files, { desc = "Telescope [f]ind [f]iles" })
set('n', '<leader>fg', builtin.live_grep, { desc = "Telescope [f]ind [g]it files" })
set('n', '<leader>,', builtin.buffers, { desc = "Telescope buffers" })
-- set('n', '<leader>fb', builtin.buffers, { })
set('n', '<leader>fh', builtin.help_tags, {})
-- set('n', '<leader>/', function() builtin.grep_string({ search = vim.fn.input('Grep > ') }) end,
--     { desc = 'Telescope Grep Search' })
set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope Grep Search' })

set('n', '<leader>fp', require("telescope").extensions.project.project, { desc = 'Telescope Project' })

set('n', '<leader>.', require("oil").toggle_float, { desc = "Toggle oil" })

-- v for version control
local neogit = require("neogit")
set('n', '<leader>v', neogit.open, { desc = 'Neogit' })
set('n', '<leader>j', vim.cmd.tabnext, { desc = 'Tab Next' })
set('n', '<leader>k', vim.cmd.tabprevious, { desc = 'Tab Previous' })
set('n', '<leader>n', vim.cmd.tabnew, { desc = 'Tab New' })
set('n', '<leader>q', vim.cmd.tabclose, { desc = 'Tab Close' })

-- toggleterm
set({ 'n', 'i', 't' }, '<C-\\>', function() vim.cmd.ToggleTerm('direction=float') end,
    { desc = 'Open Floating Terminal' })

-- Default Keybind to go into Normal Mode while in Terminal Mode is <C-\><C-n>
set('t', '<C-]>', '<C-\\><C-n>', { desc = 'Exit Terminal Mode' })

-- lsp keybinds and on_attach
set("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostic Goto next" })
set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostic Goto prev" })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

        set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover', buffer = bufnr })
        set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'LSP Format', buffer = bufnr })
        set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'LSP Rename', buffer = bufnr })
        set('n', '<leader>ca', require("tiny-code-action").code_action, { desc = 'LSP Code Action', buffer = bufnr })

        set('n', 'gd', builtin.lsp_definitions, { desc = 'LSP Goto Definition (Telescope)', buffer = bufnr })
        set('n', 'gr', builtin.lsp_references, { desc = 'LSP Find References (Telescope)', buffer = bufnr })
        set('n', 'gi', builtin.lsp_implementations, { desc = 'LSP Goto implementations (Telescope)', buffer = bufnr })
        set('n', 'gF', builtin.lsp_document_symbols, { desc = 'LSP Document Symbols (Telescope)', buffer = bufnr })
        set('n', 'gW', builtin.lsp_workspace_symbols, { desc = 'LSP Document Symbols (Telescope)', buffer = bufnr })
        set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP Goto Declaration', buffer = bufnr })

        set('n', '<leader>cd', vim.diagnostic.open_float,
            { desc = 'Diagnostic Open Float', buffer = bufnr })

        set('n', '<Leader>k', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = bufnr })

        if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true) end

        if client.server_capabilities.codeLensProvider then
            local codelens = vim.api.nvim_create_augroup(
                'LSPCodeLens',
                { clear = true }
            )
            vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'CursorHold' }, {
                group = codelens,
                callback = function()
                    vim.lsp.codelens.refresh()
                end,
                buffer = 0,
            })
        end

        if client ~= nil and client.name == "clangd" then
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
        end
    end
})

-- nvim DAP
local dap = require("dap")
set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP Toggle breakpoint" })
set("n", "<leader>gb", dap.run_to_cursor, { desc = "DAP Run to cursor" })
set("n", "<leader>?", function()
    require("dapui").eval(nil, { enter = true })
end)
set("n", "<F1>", dap.continue)
set("n", "<F2>", dap.step_into)
set("n", "<F3>", dap.step_over)
set("n", "<F4>", dap.step_out)
set("n", "<F5>", dap.step_back)
set("n", "<F12>", dap.restart)

-- local neotree = require('neo-tree.command')
-- set('n', '<leader>tt', function() neotree.execute({ action = "focus", toggle = true }) end,
--     { desc = "Toggle NeoTree" })

set('n', '<Leader>t', require('whitespace-nvim').trim, { desc = "Trim whitespace" })

set("n", "<leader>Zn", ":TZNarrow<CR>", {})
set("v", "<leader>Zn", ":'<,'>TZNarrow<CR>", {})
set("n", "<leader>Zf", ":TZFocus<CR>", {})
set("n", "<leader>Zm", ":TZMinimalist<CR>", {})
set("n", "<leader>Za", ":TZAtaraxis<CR>", {})

-- improved-ft
local map = function(key, fn, description)
    vim.keymap.set({ "n", "x", "o" }, key, fn, {
        desc = description,
        expr = true,
    })
end

local ft = require("improved-ft")

map("f", ft.hop_forward_to_char, "Hop forward to a given char")
map("F", ft.hop_backward_to_char, "Hop backward to a given char")

map("t", ft.hop_forward_to_pre_char, "Hop forward before a given char")
map("T", ft.hop_backward_to_pre_char, "Hop backward before a given char")

map(".", ft.repeat_forward, "Repeat hop forward to a last given char")
map(",", ft.repeat_backward, "Repeat hop backward to a last given char")
