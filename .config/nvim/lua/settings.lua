local opt = vim.opt

vim.g.mapleader = ' '
opt.modeline = false
opt.shell='/bin/fish'

opt.number = true
opt.relativenumber = true

opt.scrolloff = 4
opt.mouse = 'a'

opt.expandtab = false
opt.tabstop = 8
opt.shiftwidth = 8
opt.smarttab = true
opt.softtabstop = 4

opt.linebreak = true
opt.breakindent = true


-- #fold-setup using treesitter
-- TODO better fold indication
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 50   -- arbetrary large value
vim.o.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... ' . '(' . (v:foldend - v:foldstart + 1) . ' lines)']]

-- TODO find better colorscheme
vim.cmd 'colorscheme desert'
vim.api.nvim_set_hl(0, "MatchParen" , {bg="grey", fg="lightgreen" } )
