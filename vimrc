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
set nowrap
set cursorline
set title

" Cursor line settings
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=NONE


"
" Leader settings
let mapleader = "\<space>"

"
" Vim working dirs settings
set backupdir=./.backup/,$HOME/.backup// 
set directory=./.swp/,$HOME/.swp//
set undodir=./.undo/,$HOME/.undo//
set errorfile=$HOME/.tmp/error.err


"
" Vim Plug entries
"
call plug#begin()


	"
	" NERD Tree
	Plug 'scrooloose/nerdtree'
	map <F3> :NERDTreeToggle<CR>
	map <leader><F3> :NERDTreeFocus<CR>
	map <F4> :NERDTreeFind<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	autocmd FileType nerdtree setlocal relativenumber " enable line numbers
	let g:NERDTreeShowLineNumbers    = 1      " make sure relative line numbers are used
	let g:NERDTreeMapActivateNode    = 'l'    " vifm like open node on 'l'
	let g:NERDTreeMapOpenRecursively = 'L' " open node recursively
	let g:NERDTreeWinSize            = 50


	"
	" Tagbar
	Plug 'majutsushi/tagbar'
	let g:tagbar_sort = 0
	let g:tagbar_show_linenumbers = -1
	let g:tagbar_autopreview = 0
	let g:tagbar_left = 0
	nnoremap <leader><leader>t :TagbarToggle<CR>


	"
	" Quickfix and location lists pluging 
	Plug 'romainl/vim-qf'
	let g:qf_shorten_path       = 0
	let g:qf_auto_quit          = 0
	let g:qf_auto_open_quickfix = 0
	let g:qf_auto_open_loclist  = 0
	nmap <leader>n <plug>(qf_qf_next)
	xmap <leader>n <plug>(qf_qf_next)
	nmap <leader>N <plug>(qf_qf_previous)
	xmap <leader>N <plug>(qf_qf_previous)
	nmap <leader>g <plug>(qf_loc_next)
	xmap <leader>g <plug>(qf_loc_next)
	nmap <leader>G <plug>(qf_loc_previous)
	xmap <leader>G <plug>(qf_loc_previous)
	nmap <F6> <plug>(qf_qf_toggle_stay)
	xmap <F6> <plug>(qf_qf_toggle_stay)
	nmap <F7> <plug>(qf_loc_toggle_stay)
	xmap <F7> <plug>(qf_loc_toggle_stay)


	"
	" Workspace pluging and settings
	set sessionoptions-=blank
	Plug 'thaerkh/vim-workspace'
	let g:workspace_autosave = 0
	let g:workspace_session_disable_on_args = 1
	let g:workspace_autosave_ignore = ['gitcommit', 'qf', 'nerdtree', 'tagbar']


	" 
	" FZF 
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	let g:fzf_command_prefix = 'Fzf'
	" let $FZF_DEFAULT_COMMAND = 'ag -g ""'
	let $FZF_DELUALT_COMMAND = 'rg --files '
	nnoremap <C-t>  :FzfFiles<CR>
	nnoremap <leader>tt :FzfFiles <UP><CR>
	nnoremap <leader>tf :FzfFiles<Space>
	nnoremap <leader>th :FzfHistory<CR>
	nnoremap <leader>ts :FzfAg<CR>
	nnoremap <leader>tm :FzfMarks<CR>
	nnoremap <leader>tl :FzfBLines<CR>
	nnoremap <leader>tL :FzfLines<CR>
	nnoremap <leader>tb :FzfBuffers<CR>
	nnoremap <leader>tw :FzfWindows<CR>
	nnoremap <leader>tT :FzfTags<CR>
	nnoremap <leader>tBT :FzfBTags<CR>


	"
	" Vim grepper
	Plug 'mhinz/vim-grepper'
	nnoremap <leader>s :Grepper -tool ag -highlight<CR>
	nnoremap <leader>S :Grepper -tool ag -buffer -highlight<CR>
	nmap gs <plug>(GrepperOperator)
	xmap gs <plug>(GrepperOperator)
	let g:grepper = {}
	let g:grepper.quickfix = 0


	if has('nvim-0.5')
		"
		" LSP Plugin 
		Plug 'neovim/nvim-lsp'
		let g:diagnostic_enable_virtual_text = 0
		let g:diagnostic_enable_underline = 1
		Plug 'nvim-lua/diagnostic-nvim'
		Plug 'nvim-lua/lsp-status.nvim'
		Plug 'nvim-lua/completion-nvim'
		set completeopt=menuone,noinsert
		let g:completion_chain_complete_list = [
			\{'complete_items': ['lsp', 'snippet', 'tags']},
			\{'mode': '<c-p>'},
			\{'mode': '<c-n>'}
		\]
	endif


	"
	" Async run
	Plug 'skywind3000/asyncrun.vim'
	let g:asyncrun_open = 5
	let g:asyncrun_bell = 1
	nnoremap <F10> :call asyncrun#quickfix_toggle(5)<CR>
	command! -complete=shellcmd -nargs=+ Sh        AsyncRun -raw <args>
	command! -complete=shellcmd -nargs=+ Shell     AsyncRun -raw <args>
	command! -complete=file     -nargs=+ Git       Sh git <args>
	command! -complete=file     -nargs=+ GitStatus Sh git status <args>
	command! -complete=file     -nargs=+ Svn       Sh svn <args>
	command! -complete=file              SvnInfo   Svn info %
	command! -complete=file              SvnBlame  Svn blame %
	command! -complete=file              SvnRevert Svn revert %

	command! -bang -nargs=* -complete=file Run AsyncRun -raw run.bat <args>
	command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
	command! -bang -nargs=* -complete=file Clean AsyncRun -raw clean.bat <args>
	command! -bang -nargs=* -complete=file Genprj AsyncRun -raw genprj.bat <args>

	nnoremap <F5> :Run<CR>

	"
	" Clang Format
	Plug 'rhysd/vim-clang-format'
	nnoremap <leader>f :ClangFormat<CR>
	vnoremap <leader>f :ClangFormat<CR>
	let g:clang_format#detect_style_file = 1
	let g:clang_format#auto_format = 0
	let g:clang_format#auto_format_on_insert_leave = 0

	"
	" Vim mark bar 
	Plug 'Yilin-Yang/vim-markbar'

	"
	" Vim airline 
	Plug 'vim-airline/vim-airline'
	let g:airline#extensions#grepper#enabled = 1
	let g:airline#extension#term#enabled = 1
	let g:airline#extensions#nvimlsp#enabled = 1

	"
	" Other whitout special settings
	Plug 'easymotion/vim-easymotion'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-surround'
	Plug 'xolox/vim-misc'
	Plug 'kana/vim-operator-user'
	Plug 'vim-scripts/vcscommand.vim'
	Plug 'godlygeek/tabular'

call plug#end()


if has('nvim-0.5')
	lua require('lua_config')
	lua vim.lsp.set_log_level("debug")
	
	set omnifunc=v:lua.vim.lsp.omnifunc
	nnoremap <silent> <leader>i <cmd>lua vim.lsp.buf.hover()<CR>
	nnoremap <silent> <c-]>     <cmd>lua vim.lsp.buf.definition()<CR>
	nnoremap <silent> gd        <cmd>lua vim.lsp.buf.declaration()<CR>
	nnoremap <silent> gD        <cmd>lua vim.lsp.buf.implementation()<CR>
	nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>
	nnoremap <silent> gn        <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
	nnoremap <silent> g0        <cmd>lua vim.lsp.buf.document_symbol()<CR>
	"nnoremap <silent> <leader>gs <cmd>lua vim.lsp.buf.signature_help()<CR>

	command! LSPRename :lua vim.lsp.buf.rename()

	let g:lsp_diagnostics_echo_cursor = 1

	"
	" Statusline
	function! LspStatus() abort
	  if luaeval('#vim.lsp.buf_get_clients() > 0')
		return luaeval("require('lsp-status').status()")
	  endif
	  return ''
	endfunction

	let g:airline_section_y = '%{LspStatus()}'
endif


"
" Basic movement and often used commands
command Q :qa!
command W :w!

nnoremap <C-.> :<UP><CR>

nnoremap <C-J> <C-W>j
tnoremap <C-J> <C-\><C-n><C-W>j
nnoremap <C-K> <C-W>k
tnoremap <C-K> <C-\><C-n><C-W>k
nnoremap <C-H> <C-W>h
tnoremap <C-H> <C-\><C-n><C-W>h
nnoremap <C-L> <C-W>l
tnoremap <C-L> <C-\><C-n><C-W>l

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
nnoremap <ESC><ESC> :nohl<CR>
tnoremap <C-\> <C-\><C-n>
vnoremap <M-/> <Esc>/\%V

"
" FSwitch mappings
map <C-;><C-.> :FSHere<CR>
map <C-;><C-j> :FSSplitBellow<CR>
map <C-;><C-k> :FSSplitAbove<CR>
map <C-;><C-l> :FSSplitRight<CR>
map <C-;><C-h> :FSSplitLeft<CR>


"
" Custom mappings for editing
map K i<CR><ESC>
map <A-i> i<CR><ESC>O


"
" Buffers controls
map <leader>bn :bn<cr>
map <leader>bp :bp<cr>
map <leader>bl :ls<cr>
map <leader>bd :bdelete<cr>



"
" Ctags file generation
command! -complete=file -nargs=* GenerateCtags :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>


"
" Tags file settings
set tags=./tags,tags;/
set noautochdir


"
" Make settings
if has("windows")
	" MSBuild error format and settings
	set makeprg=build.bat;
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
" Highlight current word
highlight MyCurrentHighlightGroup ctermbg=green guibg=green
let g:highlight_active = 0
let g:myCurrentHighlightGroup = matchadd("MyCurrentHighlightGroup", "")
nnoremap <A-h> :call ToggleWordHighlight(expand("<cword>"))<CR>

function! HighlightCurrentWord(_word)
	let g:highlight_active = 1
	let g:myCurrentHighlightGroup = matchadd("MyCurrentHighlightGroup", a:_word)
endfunction

function! UnHighlightCurrentWord()
	call matchdelete(g:myCurrentHighlightGroup)
	let g:highlight_active = 0
endfunction

function! ToggleWordHighlight(_word)
	if g:highlight_active == 0
		call HighlightCurrentWord(a:_word)
	else
		call UnHighlightCurrentWord()
	endif
endfunction



" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
hi AutoHighlightGroup guibg=darkblue
let AutoHighlight = matchadd("AutoHighlightGroup", "")
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

function! ChangeAutoHighlight()
	for m in filter(getmatches(), { i, v -> l:v.group is? 'AutoHighlightGroup' })
		call matchdelete(m.id)
	endfor
	let AutoHighlight = matchadd("AutoHighlightGroup", '\<'.expand('<cword>').'\>')
endfunction

function! ClearAutoHighlight()
	for m in filter(getmatches(), { i, v -> l:v.group is? 'AutoHighlightGroup' })
		call matchdelete(m.id)
	endfor
endfunction

function! AutoHighlightToggle()
	if exists('#auto_highlight')
		au! auto_highlight
		augroup! auto_highlight
		setl updatetime=4000
		call ClearAutoHighlight()
		echo 'Highlight current word: off'
		return 0
	else
		augroup auto_highlight
			au!
			au CursorHold * call  ChangeAutoHighlight()
		augroup end
		setl updatetime=100
		echo 'Highlight current word: ON'
		return 1
	endif
endfunction


"
" Some special optional settings
if has("gui_running")
	set guioptions -=T
else
	"set term=xterm
	set mouse=a
	set nocompatible
endif
