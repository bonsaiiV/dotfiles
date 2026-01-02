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
local session_name = os.getenv('SESSION_NAME')
if session_name then
    vim.api.nvim_create_user_command('SessionConfig',
        function()
            local home_dir = os.getenv('HOME')
            local buf = vim.api.nvim_create_buf(true, false)
            local filename = home_dir .. '/.dotfiles/sessions/' .. session_name .. '.json'
            vim.api.nvim_buf_set_name(buf, filename)
            vim.api.nvim_buf_call(buf, function() vim.cmd.edit(filename) end)
            local opts = {win = 0, vertical = true, split = 'right'}
            vim.api.nvim_open_win(buf, true, opts)
        end,
        {desc ='edit the config for this session'}
    )
end
vim.api.nvim_create_user_command('Scratch',
    function()
        local buf = vim.api.nvim_create_buf(false, true)
        local opts = {win = 0, vertical = true, split = 'right'}
        vim.api.nvim_open_win(buf, true, opts)
    end,
    {desc ='creates a scratch buffer'}
)
