-- quickchange indenting
vim.api.nvim_create_user_command('Tabs',
    function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 8
    end,
    {desc ='use tabs for indenting'}
)
vim.api.nvim_create_user_command('Spaces',
    function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
    end,
    {desc ='use spaces for indenting'}
)
vim.api.nvim_create_user_command('Scratch',
    function()
        vim.cmd("split")
        vim.cmd("noswapfile hide enew")
        vim.opt_local.buftype='nofile'
        vim.opt_local.bufhidden='hide'
        vim.opt_local.buflisted=false
        vim.cmd("lcd ~")
    end,
    {desc ='creates a scratch buffer'}
)
