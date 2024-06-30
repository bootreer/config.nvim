require("plugins")
require("remap")

vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.mouse = "a"

vim.opt.syntax = "enable"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

vim.opt.signcolumn = "yes"

vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.ruler = true
vim.opt.cmdheight = 1
vim.opt.iskeyword:append("-")
vim.opt.cursorline = true
vim.opt.showtabline = 4
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
vim.opt.ignorecase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.list = true

vim.o.completeopt = "menuone,noinsert,noselect"

vim.g.gruvbox_material_enable_italic = false
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_transparent_background = 1
vim.g.gruvbox_material_foreground = "mix"

vim.cmd.colorscheme('gruvbox-material')
-- vim.cmd.colorscheme('gruvbox')

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

require("bufferline").setup {}

-- lualine
require('lualine').setup {
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
            'filename',
            function()
                return vim.fn['nvim_treesitter#statusline'](180)
            end },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}

vim.diagnostic.config({
    virtual_text = false,
})
