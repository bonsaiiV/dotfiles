vim.lsp.config('clangd', {
    cmd = {'clangd', '--compile-commands-dir=build'}
    ,filetypes = {'c', 'cpp'}
    ,root_markers = { '.clangd', 'build', 'bin', '.git' }
    ,settings = {
        -- Don't configure here
        -- Instead use:
        -- file:///home/bonsaiiv/.config/clangd/config.yaml
    },
})--]]

vim.lsp.enable('clangd')
