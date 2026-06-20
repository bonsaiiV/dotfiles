vim.lsp.config('ty', {
    cmd = {'ty', 'server'}
    ,filetypes = {'python'}
    ,root_markers = {'Makefile', '.git' }
    ,settings = {
    },
})--]]

vim.lsp.enable('ty')
