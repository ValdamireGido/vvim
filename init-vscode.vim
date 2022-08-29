
language en_US
set number relativenumber
set incsearch
set hlsearch
set scrolloff=5
let mapleader = "\<space>"

map <c-.> :<UP><CR>

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

" curly brackets typing easieness
imap <C-t>{ <CR>{}<ESC>i<CR>
imap <C-t>} {}<ESC>i<CR>

imap <C-t>cm /*<CR>*/<ESC>O
imap <C-t>cc //

call plug#begin('vscode-plug')
Plug 'asvetliakov/vim-easymotion'
Plug 'tpope/vim-repeat'
Plug 'tpopo/vim-surround'
call plug#end()