vim.keymap.set(
    'n',
    '<Leader>d',
    function() vim.diagnostic.open_float() end
)

vim.keymap.set(
    'n',
    '<Leader>a',
    function()
        local count = 0
        local lines = {}
        for k, diag in pairs(vim.diagnostic.get(0)) do
            count = k
            table.insert(lines, tostring(diag.lnum + 1) .. ": " .. diag.message)
        end
        if count == 0 then
            --lines = {"no diagnostics in file"}
            lines = {"you made a huge mistake cominig here"}
        end
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
        local win = vim.api.nvim_open_win(buf, true, {relative = 'win', row=3, col=10, width=100, height=12})
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
        vim.keymap.set('n', '<ESC>', function() vim.api.nvim_win_close(win,false) end, {buffer = 0})
    end
)
