if exists("b:current_syntax")
    finish
endif

syn match diagId +^\\\d* + conceal

let b:current_syntax = "diag"
