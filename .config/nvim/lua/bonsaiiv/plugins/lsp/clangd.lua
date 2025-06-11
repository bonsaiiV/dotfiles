vim.lsp.config['clangd'] = {
    cmd = {'clangd', '--compile-commands-dir=build'}
    ,filetypes = {'c'}
    ,root_markers = { '.clangd', 'build', 'bin', '.git' }
}--]]

vim.lsp.enable('clangd')
