local shiftwidth = 8

vim.opt.expandtab = false
vim.opt.shiftwidth = shiftwidth
vim.opt.tabstop = shiftwidth
vim.opt.cin = true
vim.opt.cino = ":0=" .. shiftwidth .. "l" .. shiftwidth
