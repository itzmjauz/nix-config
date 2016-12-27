set nocompatible
filetype plugin on
let &shm = 'I'
let &encoding = 'utf-8'
set shell=/bin/sh
set hidden
set undofile

" {{ keyboard behaviour
let mapleader=","
set backspace=indent,eol,start
inoremap kj <esc>
map <C-n> :NERDTreeToggle<CR>
map <C-b> :BuffergatorToggle<CR>
map <C-u> :UndotreeToggle<cr>
nmap <silent> <leader>n :silent :nohlsearch<CR>

au FileType haskell nnoremap <buffer> <leader>t :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <leader>i :HdevtoolsInfo<CR>
au FileType haskell nnoremap <buffer> <silent> <leader>c :HdevtoolsClear<CR>

" splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" }}

" {{ split behaviour
set splitbelow
set splitright
" }}

" {{ appearance
set visualbell
set t_vb=
set hlsearch
set incsearch

syntax on
filetype plugin indent on

hi clear SpellBad
hi SpellBad cterm=bold ctermbg=darkred ctermfg=white

let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_resolve_links = 1
let g:easytags_async = 1

let g:syntastic_auto_loc_list=1

let g:airline_powerline_fonts = 1
let &laststatus = 2

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let &background = 'dark'
let g:solarized_termtrans = 1
let g:solarized_termcolors = 256
let g:solarized_contrast = "high"
let g:solarized_visibility = "high"

" }}

" {{ formatting
" default indentation settings
let g:indent = 2
let &tabstop = indent
let &softtabstop = indent
let &shiftwidth = indent
set autoindent
set smartindent
set expandtab

" guess indentation settings on file load
autocmd BufReadPost * :GuessIndent

" for specific filetypes
au BufNewFile,BufRead *.md setf markdown
au BufNewFile,BufRead *.cs setf coffee
au BufNewFile,BufRead *.escad,*.scad setf javascript
au BufNewFile,BufRead *.pde,*.ino setf cpp

" for autoformatting

" various loose settings
let g:gist_detect_filetype = 1
let g:SuperTabDefaultCompletionType = "context"
let g:session_autosave = 'yes'
let g:go_disable_autoinstall = 1

let g:go_bin_path = '@goBinPath@/bin'
let g:go_doc_command = '@goBinPath@/bin/godoc'
let g:go_fmt_command = '@goBinPath@/bin/goimports'

set rtp+=@merlin@/share/ocamlmerlin/vim
let g:merlin = { 'ocamlmerlin_path': '@merlin@/bin/ocamlmerlin' }

" activate theme
colorscheme solarized

" TODO: modularise this or whatever
command -range=% Sprunge <line1>,<line2>w !sprunge

au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>r <Plug>(go-run)
au FileType go nmap <Leader>b <Plug>(go-build)
au FileType go nmap <Leader>t <Plug>(go-test)
au FileType go nmap <Leader>c <Plug>(go-rename)
au FileType go nmap gd <Plug>(go-def)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
