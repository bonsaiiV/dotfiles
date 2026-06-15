return {
    src = 'nvim-telescope/telescope.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    setup = function()
        local builtin = require('telescope.builtin')
        if os.getenv('SESSION_NAME') == 'config' then
            vim.keymap.set(
                'n',
                '<Leader>c',
                function() builtin.find_files({
                    find_command = {'ls'},
                    })
                end
            )
        end
        vim.keymap.set('n', '<Leader>g', function() builtin.live_grep() end)
        vim.keymap.set('n', '<Leader>f', function() builtin.find_files() end)
        vim.keymap.set('n', '<Leader>b', function() builtin.buffers() end)
        vim.keymap.set('n', '<Leader>p', function() builtin.planets() end)
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
