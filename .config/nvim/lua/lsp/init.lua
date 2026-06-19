require('lsp/clangd')
require('lsp/luals')
require('lsp/texlab')
require('lsp/keybinds')

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf })

        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            --client.server_capabilities.completionProvider.triggerCharacters = {"<Tab>"}

            vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = false})

            vim.keymap.set('i', '<S-Tab>', function()
                vim.lsp.completion.get()
            end, {})
        end
    end,
})
return {}
