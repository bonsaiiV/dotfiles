local function run_python()
    local result = vim.system({'python', vim.api.nvim_buf_get_name(0)}, {}):wait()
    local lines = {}
    if result.code == 0 then
        if string.len(result.stdout) == 0 then
            table.insert(lines, "no output generated")
        else
            for s in result.stdout:gmatch("[^\r\n]+") do
                table.insert(lines, s)
            end
        end
    else
        for s in result.stderr:gmatch("[^\r\n]+") do
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
        pattern = {"*.py"},
        callback = function()
            vim.opt.expandtab = true
            vim.opt.shiftwidth = 1
            vim.api.nvim_create_user_command('Run',
                run_python,
                {desc ='run buffer code in python'}
            )
            vim.keymap.set('n', '<Leader>r',
                run_python,
                {desc ='run buffer code in python'}
            )
        end
    }
)
