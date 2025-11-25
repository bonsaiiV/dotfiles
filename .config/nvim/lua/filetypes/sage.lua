local function run_sage()
    local b_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    local result = vim.system({'sage', '-c', table.concat(b_lines, '\n')}, {}):wait()
    local lines = {}
    if result.code == 0 then
        for s in result.stdout:gmatch("[^\r\n]+") do
            table.insert(lines, s)
        end
    else
        for s in result.stdout:gmatch("[^\r\n]+") do
            table.insert(lines, s)
        end
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
    local result_window = vim.api.nvim_open_win(buf, true, {relative = 'win', row=3, col=10, width=100, height=12})
    vim.wo[result_window].number = false
    vim.wo[result_window].relativenumber = false
    vim.keymap.set('n', '<ESC>', function() vim.api.nvim_win_close(result_window,false) end, {buffer = 0})
end

vim.api.nvim_create_autocmd(
    {'BufEnter'},
    {
        pattern = {"*.sage"},
        callback = function()
            vim.api.nvim_create_user_command('Run',
                run_sage,
                {desc ='run buffer code in sage math'}
            )
            vim.keymap.set('n', '<Leader>r',
                run_sage,
                {desc ='run buffer code in sage math'}
            )
        end
    }
)
