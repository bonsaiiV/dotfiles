vim.lsp.config['luals'] = {
    cmd = {'lua-language-server'}
    ,filetypes = {'lua'}
    ,root_markers = {  'init.lua', '.luarc.json', '.luarc.jsonc' , '.git' }
    ,settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            }
            ,path = {
                'lua/?.lua',
                'lua/?/init.lua',
            }
            ,workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        }
    }
}

vim.lsp.enable('luals')
