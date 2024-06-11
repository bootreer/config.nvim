vim.g.mapleader = " "
vim.g.maplocalleader = ","


-- move highlighted lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

-- TAB in normal mode will move to text buffer
vim.keymap.set("n", "<TAB>", ":bnext<CR>")
-- SHIFT-TAB will go back
vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>")

-- Better tabbing
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- tmux navigation
local nvim_tmux_nav = require("nvim-tmux-navigation")
vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope [f]ind [f]iles" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Telescope [f]ind [g]it files" })
vim.keymap.set('n', '<leader>,', builtin.buffers, { desc = "Telescope buffers" })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- vim.keymap.set('n', '<leader>/', function() builtin.grep_string({ search = vim.fn.input('Grep > ') }) end,
--     { desc = 'Telescope Grep Search' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope Grep Search' })

vim.keymap.set('n', '<leader>fp', require("telescope").extensions.project.project, { desc = 'Telescope Project' })

vim.keymap.set('n', '<leader>e', require("oil").toggle_float)

-- v for version control
local neogit = require("neogit")
vim.keymap.set('n', '<leader>v', neogit.open, { desc = 'Neogit' })
vim.keymap.set('n', '<leader>j', vim.cmd.tabnext, { desc = 'Tab Next' })
vim.keymap.set('n', '<leader>k', vim.cmd.tabprevious, { desc = 'Tab Previous' })
vim.keymap.set('n', '<leader>n', vim.cmd.tabnew, { desc = 'Tab New' })
vim.keymap.set('n', '<leader>q', vim.cmd.tabclose, { desc = 'Tab Close' })

-- toggleterm
vim.keymap.set({ 'n', 'i', 't' }, '<C-\\>', function() vim.cmd.ToggleTerm('direction=float') end,
    { desc = 'Open Floating Terminal' })

-- Default Keybind to go into Normal Mode while in Terminal Mode is <C-\><C-n>
vim.keymap.set('t', '<C-]>', '<C-\\><C-n>', { desc = 'Exit Terminal Mode' })

-- lsp keybinds
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover', buffer = event.buf })
        vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'LSP Format', buffer = event.buf })
        vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'LSP Rename', buffer = event.buf })
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Action', buffer = event.buf })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP Goto Definition', buffer = event.buf })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP Goto Declaration', buffer = event.buf })

        vim.keymap.set('n', 'gr', builtin.lsp_references,
            { desc = 'LSP Find References (Telescope)', buffer = event.buf })
        -- vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references,
        --     { desc = 'LSP Find References', buffer = event.buf })

        vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float,
            { desc = 'Diagnostic Open Float', buffer = event.buf })
        vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev,
            { desc = 'Diagnostic Goto Previous', buffer = event.buf })
        vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = 'Diagnostic Goto Next', buffer = event.buf })

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        vim.keymap.set('n', '<Leader>k', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = event.buf })
        -- if client.server_capabilities.inlayHintProvider then
        --     vim.lsp.inlay_hint.enable(event.buf)
        -- end
        require("lsp-inlayhints").on_attach(client, event.buf)
    end
})

local neotree = require('neo-tree.command')
vim.keymap.set('n', '<leader>tt', function() neotree.execute({ action = "focus", toggle = true }) end,
    { desc = "Toggle NeoTree" })


vim.api.nvim_set_keymap("n", "<leader>Zn", ":TZNarrow<CR>", {})
vim.api.nvim_set_keymap("v", "<leader>Zn", ":'<,'>TZNarrow<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>Zf", ":TZFocus<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>Zm", ":TZMinimalist<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>Za", ":TZAtaraxis<CR>", {})
