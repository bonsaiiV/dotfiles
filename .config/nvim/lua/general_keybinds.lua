vim.keymap.set(
    'n',
    'gl',
    function()
        local log = vim.system({'git', 'log', '--oneline', vim.api.nvim_buf_get_name(0)}):wait()
        local lines = {}
        for s in log.stdout:gmatch("[^\r\n]+") do
            table.insert(lines, s)
        end
        if #lines == 0 then
            lines = {"not a git repository"}
        end
        require('functions/utils').open_std_float(lines, 30)
    end
)
