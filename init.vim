
nnoremap ,c :tabe $HOME/AppData/Local/nvim/init.vim<CR>

source $HOME/AppData/Local/nvim/.vimrc.custom

set title
set errorfile=C:/.tmp/errorfile

if has('windows')
	command TEST :echo Test
endif

call plug#begin('~/AppData/Local/nvim/plugged')
Plug 'neomake/neomake'
Plug '/c/ProgramData/chocolatey/bin/fzf'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'mhinz/vim-grepper'
Plug 'Lenovsky/nuake'
nnoremap <F4> :Nuake<CR>
inoremap <F4> <C-\><C-n>:Nuake<CR>
tnoremap <F4> <C-\><C-n>:Nuake<CR>
call plug#end()



"
" Async Vimgrep 
" usage: :Vimgrep /foo/ **
"

function! s:exit_handler(id, data, event) dict abort
  execute 'cfile' self.tempfile
  copen
endfunction

function! s:vimgrep(args) abort
  let tempfile = tempname()

  let commands  = [ 'noautocmd vimgrep '. a:args ]
  let commands += [ 'let matches = map(getqflist(), "printf(\"%s:%d:%d:%s\", bufname(v:val.bufnr), v:val.lnum, v:val.col, v:val.text)")' ]
  let commands += [ 'call writefile(matches, "'. tempfile .'")' ]
  let commands += [ 'quitall!' ]

  let cmd = join(map(commands, '"+".shellescape(v:val)'))

  if has('nvim')
    call jobstart('nvim '. cmd, {
          \ 'on_exit': function('s:exit_handler'),
          \ 'tempfile': tempfile,
          \ })
  else
    echomsg 'job_start() implementation missing'
  endif
endfunction

command! -nargs=* -bang Vimgrep call s:vimgrep('<args>')

