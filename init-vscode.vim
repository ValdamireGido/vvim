
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

call plug#begin('vscode-plug')
Plug 'asvetliakov/vim-easymotion'
Plug 'tpope/vim-repeat'
Plug 'tpopo/vim-surround'
call plug#end()