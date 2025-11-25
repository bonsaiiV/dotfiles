vim.api.nvim_create_autocmd(
    {'BufEnter'},
    {
        pattern = {"*.json"},
        callback = function()
            vim.api.nvim_create_user_command('Format',
                function()
                    local b_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
                    local formatted_json = vim.system({'jq', '--tab'}, {stdin = table.concat(b_lines, '\n')}):wait()
                    local lines = {}
                    for s in formatted_json.stdout:gmatch("[^\r\n]+") do
                        table.insert(lines, s)
                    end
                    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
                end,
                {desc ='run buffer through jq'}
            )
        end
    }
)
