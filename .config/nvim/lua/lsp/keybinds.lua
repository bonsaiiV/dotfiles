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
        local diagnostics = vim.diagnostic.get(0)
        for k, diag in pairs(diagnostics) do
            count = k
            table.insert(lines, tostring(diag.lnum + 1) .. ": " .. diag.message)
        end
        if count == 0 then
            --lines = {"no diagnostics in file"}
            lines = {"you made a huge mistake cominig here"}
        end
        local old_win = vim.fn.win_getid()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
        local diag_win = vim.api.nvim_open_win(buf, true, {relative = 'win', row=3, col=10, width=100, height=12})
        vim.wo[diag_win].number = false
        vim.wo[diag_win].relativenumber = false
        vim.keymap.set('n', '<ESC>', function() vim.api.nvim_win_close(diag_win,false) end, {buffer = 0})
        vim.keymap.set('n', '<Enter>',
            function()
                local diag_index = vim.api.nvim_win_get_cursor(diag_win)[1]
                local diag_line = diagnostics[diag_index].lnum + 1
                vim.api.nvim_win_set_cursor(old_win, {diag_line, 0})
                vim.api.nvim_win_close(diag_win,false)
            end, {buffer = 0})
    end
)
