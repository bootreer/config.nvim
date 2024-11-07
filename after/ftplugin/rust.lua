-- vim.keymap.set(
--     "n",
--     "<leader>ca",
--     function()
--         vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
--         -- or vim.lsp.buf.codeAction() if you don't want grouping.
--     end,
--     { silent = true, buffer = 0 }
-- )

vim.keymap.set(
    "n",
    "<localleader>rr",
    function()
        vim.cmd.RustLsp("run")
    end,
    { desc = "run", silent = true, buffer = 0 }
)

vim.keymap.set(
    "n",
    "<localleader>rR",
    function()
        vim.cmd.RustLsp("runnables")
    end,
    { desc = "runnables", silent = true, buffer = 0 }
)
vim.keymap.set(
    "n",
    "<localleader>rd",
    function()
        vim.cmd.RustLsp("debug")
    end,
    { desc = "debug", silent = true, buffer = 0 }
)

vim.keymap.set(
    "n",
    "<localleader>rD",
    function()
        vim.cmd.RustLsp("debuggables")
    end,
    { desc = "debuggables", silent = true, buffer = 0 }
)
