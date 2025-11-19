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
require 'lazy'.setup('plugins', {
    change_detection = {
        notify = false,
    },
})

vim.api.nvim_create_autocmd(
    {'VimLeavePre'},
    {
        pattern = {"*"},
        callback = function(ev)
            if vim.v.this_session ~= "" then
                vim.api.nvim_command('mksession! ' .. vim.v.this_session)
                return
            end

            local s_name = os.getenv('SESSION_NAME')
            local window_num = vim.system({'tmux', 'display-message', '-p', '#I'}):wait()["stdout"]
            if s_name and window_num == "1\n" then
                local cache = os.getenv('XDG_CACHE_HOME')
                local cache_file = cache .. '/sessions/' .. s_name .. '.vim'
                vim.cmd('mksession! ' ..  cache_file)
            end
        end
    }
)

require('filetypes')
require('lsp')
