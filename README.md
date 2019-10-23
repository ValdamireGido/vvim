# valdamire-vim
Custom build of vim with all the plugins I'm using. 

Plugins:
- Pathogen (copied to autoload): https://github.com/tpope/vim-pathogen
- FSwitch vim (copied to plugin): https://github.com/derekwyatt/vim-fswitch

Pathogen bundles: 
- Vim git gutter: https://github.com/airblade/vim-gitgutter
- Vim svn gutter: https://github.com/vim-scripts/vim-svngutter
- NERD Tree: https://github.com/scrooloose/nerdtree
- NERD Tree git plugin: https://github.com/Xuyuanp/nerdtree-git-plugin
- Vim Lightline: https://github.com/itchyny/lightline.vim
- Vim clang format: https://github.com/rhysd/vim-clang-format
- Vim operator user: https://github.com/kana/vim-operator-user
- Vim multiple cursors: https://github.com/terryma/vim-multiple-cursors
- Vim repeat: https://github.com/tpope/vim-repeat
- Vim surround: https://github.com/tpope/vim-surround

Just clone this repo to your vim $HOME dir:

```git clone https://github.com/ValdamireGido/vvim.git .```

Init submodules:

```git submodules --init --recursive```

There is also a custom .vimrc that you can link in local vimrc with:

```source $HOME/.vim/.vimrc.custom```

Local vimrc example
```
nnoremap ,c :tabedit c:/vim/_vimrc<CR>
source $HOME/vimfiles/.vimrc.custom

" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim
```
