return {
    print_table = function(in_table)
        local parents = {}
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
            , -1
            , false
            , lines
        )

        local table_win = vim.api.nvim_open_win(
            buf
            , true
            , {relative = 'win', row=3, col=10, width=100, height=12}
        )

        vim.wo[table_win].relativenumber = false

        vim.keymap.set(
            'n'
            , '<ESC>'
            , function() vim.api.nvim_win_close(table_win,false) end
            , {buffer = buf}
        )
        vim.keymap.set(
            'n'
            , '-'
            , function()
                if (#parents == 0) then
                    return
                end
                in_table = table.remove(parents, #parents)
                lines = {}
                for key, value in pairs(in_table) do
                    local line_start = " "
                    for value_line in string.gmatch(tostring(value), "[^\n]+") do
                        table.insert(lines, tostring(key) .. ":" .. line_start .. value_line)
                        line_start = "\t"
                    end
                end
                vim.api.nvim_buf_set_lines(
                    buf
                    , 0
                    , -1
                    , false
                    , lines
                )
            end
            , {buffer = buf}
        )
        vim.keymap.set(
            'n'
            , '<Enter>'
            , function()
                local buf_line_nr = vim.api.nvim_win_get_cursor(table_win)[1]
                local buf_line = vim.api.nvim_buf_get_lines(buf, buf_line_nr-1, buf_line_nr, true)
                local entry_start, entry_end, _ = string.find(buf_line[1], "[^:]+")
                if (not entry_start) then return end
                local table_entry = string.sub(buf_line[1], entry_start, entry_end)
                if (not in_table[table_entry]) then
                    return
                end
                table.insert(parents, in_table)
                in_table = in_table[table_entry]
                lines = {}
                for key, value in pairs(in_table) do
                    local line_start = " "
                    for value_line in string.gmatch(tostring(value), "[^\n]+") do
                        table.insert(lines, tostring(key) .. ":" .. line_start .. value_line)
                        line_start = "\t"
                    end
                end
                vim.api.nvim_buf_set_lines(
                    buf
                    , 0
                    , -1
                    , false
                    , lines
                )
            end
            , {buffer = 0}
        )
    end,
}
