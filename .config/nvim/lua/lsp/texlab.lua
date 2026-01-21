vim.lsp.config['texlab'] = {
    cmd = {'texlab', 'run'}
    ,filetypes = {'tex'}
    ,settings = {
        texlab = {
            build = {
                executable = "tectonic"
                ,args = {
                    "%f"
                    ,"--synctex"
                    ,"--keep-logs"
                    ,"--keep-intermediates"
                }
                ,onSave = true
            }
        }
    }
}--]]

vim.lsp.enable('texlab')
