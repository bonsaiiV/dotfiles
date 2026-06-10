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
    },--]]
    {
        'stevearc/oil.nvim',
        -- this will be passed to the setup function
        opts = {
            keymaps = {
                -- TODO: configure keymaps
                ["<Leader>y"] = {function()
                    local oil = require('oil')
                    local utils = require('utils')
                    local entry = oil.get_cursor_entry()
                    vim.fn.setreg('', 'file://' .. oil.get_current_dir() .. entry.name)
                    -- utils.print_table(entry)
                end, mode = "n"},
            }
        },
    },
}
