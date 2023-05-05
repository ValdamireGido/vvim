
language en_US
set number relativenumber
set incsearch
set hlsearch
set scrolloff=5
let mapleader = "\<space>"

map <c-.> :<UP><CR>
map K i<CR><ESC>

" curly brackets typing easieness
imap <C-t>{ <CR>{}<ESC>i<CR>
imap <C-t>} {}<ESC>i<CR>

imap <C-t>cm /*<CR>*/<ESC>O
imap <C-t>cc //

nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

""" Launguage specific definitions
augroup filetype_python
    autocmd!

    " Python
    au FileType python nnoremap <buffer> [[ ?^class\\|^\s*def<CR>
    au FileType python nnoremap <buffer> ]] /^class\\|^\s*def<CR>

    au FileType python nmap ( ?^\s*def\s<CR>
    au FileType python nmap ) /^\s*def\s<CR>

augroup END
