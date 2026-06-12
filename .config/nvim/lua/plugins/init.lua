local packages = {
    {
        name = 'lukas-reineke/indent-blankline.nvim',
        setup = function()
            local tty = vim.fn.getenv 'TERM' == 'linux'
            require('ibl').setup({
                indent = { char = tty and '|' or nil },
                scope = {
                    include = {
                        node_type ={
                            lua = { 'table_constructor' },
                        },
                    },
                }
            })
        end,
    },
    {
        name = 'stevearc/oil.nvim',
        setup = function()
            local oil = require('oil')
            oil.setup({
                keymaps = {
                ['<Leader>y'] =
                function()
                    local entry = oil.get_cursor_entry()
                    vim.fn.setreg('', 'file://' .. oil.get_current_dir() .. entry.name)
                    -- local utils = require('utils')
                    -- utils.print_table(entry)
                end
                }
            })
        end,
    }
}
table.insert(packages, require 'plugins/telescope')

for _, package in ipairs(packages) do
    if package.dependencies then
        for _, dep in ipairs(package.dependencies) do
            vim.pack.add({'https://github.com/' .. dep})
        end
    end
    if package.name then
        vim.pack.add({'https://github.com/' .. package.name})
    end
    if package.setup then
        package.setup()
    end
end
