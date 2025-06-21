require('lsp/clangd')
require('lsp/luals')
require('lsp/keybinds')

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf })
    end,
})
return {}
