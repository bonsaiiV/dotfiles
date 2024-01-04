vim.g.mapleader = ' '
local opt = vim.opt

opt.number		= true
opt.relativenumber	= true
-- TODO: lookup help
opt.tabstop		= 4
opt.shiftwidth		= 4
opt.smarttab		= true
opt.softtabstop		= 4

opt.linebreak = true
opt.breakindent = true

opt.mouse		= 'a'

-- Fix terrible float color
vim.cmd 'colorscheme desert'
--vim.api.nvim_set_hl(0, 'Pmenu', {bg = '#555555'})

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
