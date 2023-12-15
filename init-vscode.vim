xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

nnoremap j gj
nnoremap k gk

" curly brackets typing easieness
imap <C-t>{ <CR>{}<ESC>i<CR>
imap <C-t>} {}<ESC>i<CR>

" comments
imap <C-t>cm /*<CR>*/<ESC>O
imap <C-t>cc //

" arguments jumps
nmap ga f,w
nmap gA F,b

call plug#begin('vscode-plug')
"  Plug 'asvetliakov/vim-easymotion'
"  Plug 'tpope/vim-repeat'
"  Plug 'tpopo/vim-surround'
call plug#end()

""" Launguage specific definitions
augroup filetype_python
    autocmd!

    " Python
    au FileType python nnoremap <buffer> [[ ?^class\\|^\s*def<CR>
    au FileType python nnoremap <buffer> ]] /^class\\|^\s*def<CR>

    au FileType python nnoremap ( ?^\s*def\s<CR>
    au FileType python nnoremap ) /^\s*def\s<CR>

augroup END
