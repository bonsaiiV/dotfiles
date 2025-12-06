vim.keymap.set(
    'n',
    '<Leader>d',
    function() vim.diagnostic.open_float() end
)
local function all_diagnostics()
    local count = 0
    local lines = {}
    local diagnostics = vim.diagnostic.get(0)
    for k, diag in pairs(diagnostics) do
        count = k
        table.insert(lines, "\\" .. tostring(k) .. " " .. tostring(diag.lnum + 1) .. ": " .. diag.message)
    end
    if count == 0 then
        lines = {"you made a huge mistake cominig here"}
    end
    local old_win = vim.fn.win_getid()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(
        buf
        , 0
        , 0
        , false
        , lines
    )

    local diag_win = vim.api.nvim_open_win(
        buf
        , true
        , {relative = 'win', row=3, col=10, width=100, height=12}
    )
    vim.opt.conceallevel = 3
    vim.opt.concealcursor = "nvic"
    vim.opt.syntax = "diag"

    vim.wo[diag_win].number = false
    vim.wo[diag_win].relativenumber = false

    vim.keymap.set(
        'n'
        , '<ESC>'
        , function() vim.api.nvim_win_close(diag_win,false) end
        , {buffer = 0}
    )
    vim.keymap.set(
        'n'
        , '<Enter>'
        , function()
            local buf_line_nr = vim.api.nvim_win_get_cursor(diag_win)[1]
            local buf_line = vim.api.nvim_buf_get_lines(buf, buf_line_nr-1, buf_line_nr, true)
            local diag_index = string.match(buf_line[1], "%d+")
            local diag_line_nr = diagnostics[tonumber(diag_index)].lnum + 1
            vim.api.nvim_win_set_cursor(old_win, {diag_line_nr, 0})
            vim.api.nvim_win_close(diag_win,false)
        end
        , {buffer = 0}
    )
    vim.keymap.set(
        'n'
        , '<Leader>a'
        , function() end
        , {buffer = buf}
    )
    vim.keymap.set(
        'n'
        , '<Leader>d'
        , function() end
        , {buffer = buf}
    )
end

vim.keymap.set(
    'n'
    , '<Leader>a'
    , all_diagnostics
)
