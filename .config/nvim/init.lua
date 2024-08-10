vim.g.mapleader = ' '
require('bonsaiiv/filetypes/glsl')
local opt = vim.opt
local api = vim.api

opt.shell='/bin/fish'

opt.number		= true
opt.relativenumber	= true
opt.scrolloff = 4
-- TODO: lookup help
opt.tabstop		= 4
opt.shiftwidth		= 4
opt.smarttab		= true
opt.softtabstop		= 4

opt.linebreak = true
opt.breakindent = true

opt.mouse		= 'a'

-- #fold-setup using treesitter
-- TODO better fold indication
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 50
vim.o.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... ' . '(' . (v:foldend - v:foldstart + 1) . ' lines)']]

-- TODO find better colorscheme
vim.cmd 'colorscheme desert'

-- plugin setup using lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require 'lazy'.setup('bonsaiiv/plugins', {
	change_detection = {
		notify = false,
	},
})
