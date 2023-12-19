syntax match todoLine "^-\s.*"
syntax match doneLine "^\v\+\s.*"
syntax match mehLine "^\v\*\s.*"

highlight todoLine guibg=#d7af5f guifg=#333333 ctermfg=3 ctermbg=0
highlight doneLine guibg=#afd700 guifg=#333333 ctermfg=2 ctermbg=0
highlight mehLine  guibg=#5fafd7 guifg=#ffffff ctermfg=9 ctermbg=0
