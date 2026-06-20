require('settings')
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
require('general_keybinds')
