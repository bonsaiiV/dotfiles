local tty = vim.fn.getenv 'TERM' == 'linux'

return {
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            indent = { char = tty and '|' or nil },
            scope = {
                include = {
                    node_type ={
                        lua = { 'table_constructor' },
                    },
                },
            },
        }
    },
    {
        'stevearc/oil.nvim',
        opts = {},
    },
}
