vim.g.mapleader = " "
-- Normal modes
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<C-v>", ":r ~/.vimbuffer<CR>")


-- Visual modes
vim.keymap.set("v", "<C-c>", "y:new ~/.vimbuffer<CR>VGp:x<CR> | :!cat ~/.vimbuffer | clip.exe <CR><CR>")
-- Also a yank event version
vim.api.nvim_create_autocmd("TextYankPost", {
    command = "* call system('echo '.shellescape(join(v:event.regcontents, \"\\<CR>\")).' |  clip.exe')"
})

-- X modes
vim.keymap.set("x", "<leader>p", "\"_dP")
