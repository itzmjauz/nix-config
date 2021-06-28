let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Needed for polyglot
set nocompatible

" Install plugins
call plug#begin()
  Plug 'preservim/nerdtree'
  Plug 'shaunsingh/nord.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'sheerun/vim-polyglot'  
call plug#end()

" Border visible
let g:nord_contrast = 1
let g:nord_borders = 1
let g:nord_disable_background = 0
" load theme
colorscheme nord

" start nerdtree on nvim start
autocmd VimEnter * NERDTree | wincmd p

" Hotkeys
" NerdTRee
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
