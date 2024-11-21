return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<Leader>g', function() builtin.live_grep() end)
        vim.keymap.set('n', '<Leader>f', function() builtin.find_files() end)
        vim.keymap.set('n', '<Leader>b', function() builtin.buffers() end)
        vim.api.nvim_create_user_command(
            'Buffers',
            function ()
                builtin.buffers()
            end,
            {}
        )
        vim.api.nvim_create_user_command(
            'Grep',
            function ()
                builtin.live_grep()
            end,
            {}
        )
        vim.api.nvim_create_user_command(
            'Files',
            function ()
                builtin.find_files()
            end,
            {}
        )
    end,
}
