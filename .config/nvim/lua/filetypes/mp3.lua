vim.api.nvim_create_autocmd(
    {'BufReadCmd'},
    {
        pattern = {"*.mp3"},
        callback = function(ev)
            local format = "-pFile:\t%f\nTitle:\t%t\nArtist:\t%a\nAlbum:\t%l\nYear:\t%y\nComment:\t%c\n\n"
            local info = vim.system({'mp3info', format, ev.file}):wait()
            --print(vim.inspect(info))
            local lines = {}
            for s in info.stdout:gmatch("[^\r\n]+") do
                table.insert(lines, s)
            end

            vim.api.nvim_buf_set_lines(0, 0, 1, true, lines)
        end
    }
)

vim.api.nvim_create_autocmd(
    {'BufWriteCmd'},
    {
        pattern = {"*.mp3"},
        callback = function(ev)
            local flags_table = {}
            flags_table['Title'] = '-t'
            flags_table['Author'] = '-a'
            flags_table['Album'] = '-l'
            flags_table['Year'] = '-y'
            flags_table['Comment'] = '-c'
            if (not vim.bo.modified) then
                return
            end
            local b_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
            local cmd = {'mp3info'}
            for _, l in pairs(b_lines) do
                local words = {}
                for w in l:gmatch("[^\t:]+") do
                    table.insert(words, w)
                end
                if (words[2] == nil) then
                    goto continue
                end
                local flag = flags_table[words[1]]
                if (flag == nil) then
                    goto continue
                end
                table.insert(cmd, flag .. words[2])
                ::continue::
            end
            table.insert(cmd, ev.file)
            vim.system(cmd)
            vim.bo.modified = false
        end
    }
)
