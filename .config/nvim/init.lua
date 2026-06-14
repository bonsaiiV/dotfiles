vim.g.mapleader = ' '
local opt = vim.opt
local api = vim.api

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
api.nvim_set_hl(0, "MatchParen" , {bg="grey", fg="lightgreen" } )

require('plugins')

vim.api.nvim_create_autocmd(
    {'VimLeavePre'},
    {
        pattern = {"*"},
        callback = function(ev)
            local s_name = os.getenv('SESSION_NAME')
            --[[local log_file = io.open(os.getenv('HOME') .. '/nvim_' .. s_name .. '.log', "w")
            if log_file then
                io.output(log_file)
            else
                vim.system({'touch', os.getenv('HOME') .. '/log_file_in_' .. s_name .. '_broken'})
                --io.write('path "this_session" taken\n')
            end--]]

            if vim.v.this_session ~= "" then
                vim.api.nvim_command('mksession! ' .. vim.v.this_session)
                return
            end

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
