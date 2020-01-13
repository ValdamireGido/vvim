
nnoremap ,c :tabe $HOME/AppData/Local/nvim/init.vim<CR>

source $HOME/AppData/Local/nvim/.vimrc.custom

set title
set errorfile=C:/.tmp/errorfile





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

