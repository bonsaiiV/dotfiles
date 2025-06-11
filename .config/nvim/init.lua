vim.g.mapleader = ' '
local opt = vim.opt
local api = vim.api

opt.shell='/bin/fish'

opt.number        = true
opt.relativenumber    = true
opt.scrolloff        = 4
opt.expandtab        = false
opt.tabstop        = 8
opt.shiftwidth        = 8
opt.smarttab        = true
opt.softtabstop        = 4

opt.linebreak = true
opt.breakindent = true

opt.mouse        = 'a'

-- #fold-setup using treesitter
-- TODO better fold indication
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 50   -- arbetrary large value
vim.o.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... ' . '(' . (v:foldend - v:foldstart + 1) . ' lines)']]

-- TODO find better colorscheme
vim.cmd 'colorscheme desert'
api.nvim_set_hl(0, "MatchParen" , {bg="grey", fg="lightgreen" } )

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
api.nvim_create_user_command('Tabs',
    function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
    end,
    {desc ='use tabs for indenting'}
)
api.nvim_create_user_command('Spaces',
    function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
    end,
    {desc ='use spaces for indenting'}
)
api.nvim_create_user_command('Scratch',
    function()
        vim.cmd("split")
        vim.cmd("noswapfile hide enew")
        vim.opt_local.buftype='nofile'
        vim.opt_local.bufhidden='hide'
        vim.opt_local.buflisted=false
        vim.cmd("lcd ~")
    end,
    {desc ='creates a scratch buffer'}
)
require('bonsaiiv/filetypes')
