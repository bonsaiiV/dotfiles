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
        local buf = vim.api.nvim_create_buf(false, true)
        local opts = {win = 0, vertical = true, split = 'right'}
        local win = vim.api.nvim_open_win(buf, true, opts)
    end,
    {desc ='creates a scratch buffer'}
)
