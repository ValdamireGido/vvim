let g:pluginInstallPath = stdpath('cache')."/plugged"
" vim plug to neovim lazy adapter
source ~/AppData/Local/nvim/plug_lazy_adapter.vim
" common settings
source ~/AppData/Local/nvim/init-common.vim
colorscheme jellybeans
noremap ,cv :tabe $MYVIMRC<CR>
noremap ,cl :tabe ~/AppData/Local/nvim/lua/init.lua<cr>

" syntax higlighing
syntax on
filetype on

" Generic stuff
" Number and relative number setting
set tabstop=4
set shiftwidth=4
set scrolloff=5
set number relativenumber
set incsearch
set hlsearch
set cursorline
set title


" Cursor line settings
hi CursorLine cterm=NONE ctermbg=black ctermfg=NONE


let mapleader="\<space>"



"
" Vim Plugin entries
"
if !has('nvim')
	call plug#begin(g:pluginInstallPath)
endif

	"
	" Tagbar
	Plugin 'majutsushi/tagbar'
	let g:tagbar_sort = 0
	let g:tagbar_show_linenumbers = -1
	let g:tagbar_autopreview = 0
	let g:tagbar_left = 0
	nnoremap <leader><leader>t :TagbarToggle<CR>

	if !exists('g:vscode')
	endif

	"
	" Other whitout special settings
	Plugin 'xolox/vim-misc'
	Plugin 'vim-scripts/vcscommand.vim'

if !has('nvim')
	call plug#end()
else
	" lua require("config.lazy")
endif


lua require('init')
lua require('lua_config')
if !exists('g:vscode')
	lua require('lsp_config')
	lua vim.lsp.set_log_level("debug")
	set omnifunc=v:lua.vim.lsp.omnifunc
	let g:lsp_diagnostics_echo_cursor = 1

	autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
endif

map <F3> :NvimTreeToggle<cr>


"
" Basic movement and often used commands

command Q :qa!
command W :w!

nnoremap <A-left> <C-W>h
nnoremap <A-right> <C-W>l
nnoremap <A-up> <C-W>k
nnoremap <A-down> <C-W>j

nnoremap <A-j> <C-W>j
tnoremap <A-j> <C-\><C-n><C-W>j
nnoremap <A-k> <C-W>k
tnoremap <A-k> <C-\><C-n><C-W>k
nnoremap <A-h> <C-W>h
tnoremap <A-h> <C-\><C-n><C-W>h
nnoremap <A-l> <C-W>l
tnoremap <A-l> <C-\><C-n><C-W>l

nnoremap <C-W>m <C-W>25-<C-W>25<
nnoremap <C-W>M <C-W>25+<C-W>25>


"
" Copy/Paste (For windows copy buffer currently.
" Have plans to adjust it for use with unix like aslo)
nnoremap <A-p> "+p
inoremap <A-p> "+p
vnoremap <A-p> "+p
nnoremap <A-y> "+y
inoremap <A-y> "+y
vnoremap <A-y> "+y


"
" change current working dir to file's working dir
command CDC cd %:p:h
command CDP cd -


"
" nohl hotkey and exit terminal mode
tnoremap <C-\> <C-\><C-n>
vnoremap <M-/> <Esc>/\%V


"
" FSwitch mappings
map <C-;><C-.> :FSHere<CR>
map <A-o> :FSHere<cr>


"
" Ctags file generation
command! -complete=file -nargs=* GenerateCtags :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>


"
" Tags file settins
set tags=./tags,tags;/
set noautochdir


"
" Make settings
if has("windows")
	" MSBuild error format and settings
	set makeprg=build.bat
	set errorfile=C:/.tmp/errorfile
	"set errorformat=\ %#%f(%l\\\,%c):\ %m
	"set errorformat+=%-G%.%#
	"set errorformat=%f:%l:%c:\ %t%s:\ %m
elseif has("unix")
	let s:uname = system("uname -s")
	if s:uname == "Darwin"
		" Mac OS xcodebuild error format and settings
		set makeprg=./build.sh
		set efm=%+G[x]\ %f:%l:%c:\ %m
		set efm+=%+G[x]\ error:\ %f:\ %m
		"set efm+%+G[!]\ %f:%l:%ct\ %m
		set efm+=%-G%.%#
	else
		" linux error format and settings
	endif
endif


"
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction


"
" ex command for toggling hex mode - define mapping if desired
command -bar Hex call ToggleHex()


" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

"
" Some special optional settings
if has("gui_running")
	"set guioptions -=T
else
	"set term=xterm
	set mouse=a
	set nocompatible
endif

