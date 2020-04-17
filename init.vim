
nnoremap ,c :tabe $HOME/AppData/Local/nvim/init.vim<CR>
source $HOME/AppData/Local/nvim/.vimrc.custom

set title
set errorfile=C:/.tmp/errorfile


" MSBuild settings 
set makeprg=build.bat;
set errorformat=\ %#%f(%l\\\,%c):\ %m
"set errorformat+=%-G%.%#
set shell=cmd
set shellcmdflag =/c
