" hide diagonstics id in diagnostics window, as that is not relevant for the
" user
if exists("b:current_syntax")
    finish
endif

syn match diagId +^\\\d* + conceal

let b:current_syntax = "diag"
