return {
    print_table = function(in_table)
        local lines = {}
        for key, value in pairs(in_table) do
            local line_start = " "
            for value_line in string.gmatch(tostring(value), "[^\n]+") do
                table.insert(lines, tostring(key) .. ":" .. line_start .. value_line)
                line_start = "\t"
            end
        end
        local buf = vim.api.nvim_create_buf(false, true)

        vim.api.nvim_buf_set_lines(
            buf
            , 0
            , 0
            , false
            , lines
        )

        local table_win = vim.api.nvim_open_win(
            buf
            , true
            , {relative = 'win', row=3, col=10, width=100, height=12}
        )

        vim.keymap.set(
            'n'
            , '<ESC>'
            , function() vim.api.nvim_win_close(table_win,false) end
            , {buffer = buf}
        )
    end,
}
