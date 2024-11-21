local api = vim.api
api.nvim_create_user_command(
    'Test',
    function()
        vim.cmd("split")
        --vim.cmd("noswapfile hide enew")
        vim.opt_local.buftype='nofile'
        vim.opt_local.bufhidden='hide'
        vim.opt_local.buflisted=false
        --opt.filetype='ledger'
    end,
    {}
)
api.nvim_create_user_command('Filter',
    function()
        local lines = api.nvim_buf_get_lines(0, 0, -1, false)

    end,
    {desc ='creates a scratch buffer'}
)
