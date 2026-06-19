local packages = {
    {
        src = 'lukas-reineke/indent-blankline.nvim',
        name = 'ibl',
        setup = function()
            local ok, ibl = pcall(require, 'ibl')
            if not ok then
                return
            end
            local tty = vim.fn.getenv 'TERM' == 'linux'
            ibl.setup({
                indent = { char = tty and '|' or nil },
                scope = {
                    include = {
                        node_type ={
                            lua = { 'table_constructor' },
                        },
                    },
                }
            })--]]
        end,
    },
    {
        src = 'stevearc/oil.nvim',
        setup = function()
            local ok, oil = pcall(require, 'oil')
            if not ok then
                return
            end
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
    if package.src then
        package.src = 'https://github.com/' .. package.src
        vim.pack.add({package})
    end
    if package.setup then
        package.setup()
    end
end
