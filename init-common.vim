
language en_US
set number relativenumber
set incsearch
set hlsearch
set scrolloff=5

map <c-.> :<UP><CR>

nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

""" Launguage specific definitions
augroup filetype_python
    autocmd!

    " Python
    au FileType python nnoremap <buffer> [[ ?^class\\|^\s*def<CR>
    au FileType python nnoremap <buffer> ]] /^class\\|^\s*def<CR>

    au FileType python nmap (( ?^\s*def\s<CR>
    au FileType python nmap )) /^\s*def\s<CR>

augroup END


"
" Some filespecific filetypes
augroup wscript_filetype
	au! 
	autocmd BufNewFile,BufRead wscript 	set ft=python
augroup END

augroup entry_points_filetype
	au!
	autocmd BufNewFile,BufRead entry_points set ft=json
augroup END

augroup avalauncher_project_filetype
	au!
	autocmd BufNewFile,BufRead *.avalauncher-project set ft=json
augroup END

