vim.api.nvim_create_autocmd(
    {'BufReadCmd'},
    {
        pattern = {"*.so", "*.so.*", ".elf"},
        callback = function(ev)
            print("loading elf")
            local dump = vim.system({'objdump', "-D", ev.file}):wait()
            --print(vim.inspect(info))
            local lines = {}
            for s in dump.stdout:gmatch("[^\r\n]+") do
                table.insert(lines, s)
            end

            vim.api.nvim_buf_set_lines(0, 0, 1, true, lines)
        end
    }
)

vim.api.nvim_create_autocmd(
    {'BufWriteCmd'},
    {
        pattern = {"*.so", "*.so.*", ".elf"},
        callback = function()
            if (not vim.bo.modified) then
                return
            end
            print("this buffer is readonly")
        end
    }
)
