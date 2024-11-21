local api = vim.api;

local function inspect()
    --in old buffer
    local lines = api.nvim_buf_get_lines(0, 0, -1, false)
    --create new window and buffer
    vim.cmd("split")
    vim.cmd("noswapfile hide enew")
    vim.opt_local.buftype='nofile'
    vim.opt_local.bufhidden='hide'
    vim.opt_local.buflisted=false
    --in new buffer
    api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt.filetype='ledger'
end

api.nvim_create_user_command(
    'Inspect',
    inspect,
    {}
)
