" {{ Install plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}

" {{ Setup default
"set nocompatible
filetype plugin on
"let &shm = 'I'
"let &encoding = 'utf-8'
set shell=/bin/sh
"set hidden
"set undofile
"set number
set undodir=~/.undodir
" set t_Co=256 " terminal colors
" ?set omnifunc=syntaxcomplete#Complete
" }}

" {{ Install plugins
call plug#begin()
  Plug 'akinsho/nvim-bufferline.lua'
  Plug 'siduck76/nvim-base16.lua'
  Plug 'Pocco81/TrueZen.nvim'
  Plug 'hrsh7th/nvim-compe'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'windwp/nvim-autopairs'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'sheerun/vim-polyglot'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope-media-files.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'glepnir/galaxyline.nvim'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'sbdchd/neoformat'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'andymass/vim-matchup'
  Plug 'terrortylor/nvim-comment'
  Plug 'glepnir/dashboard-nvim'
  Plug 'karb94/neoscroll.nvim'
  "Plug 'lukas-reineke/indent-blankline.nvim'
call plug#end()
" }}
" {{start with the lua config
lua << EOF
require "config/top-bufferline"
require "config/misc-utils"

local g = vim.g
g.mapleader = " "
--g.autosave = 0

--configure plugins
require("config/zenmode").config() --trueZen
require("config/compe-completion").config()  -- compe
require("config/compe-completion").snippets() -- compe luaSnip
require("nvim-autopairs").setup() -- autopairs
require("config/telescope-nvim").config() -- telescope ( and 4 plugs after it)
-- TODO > wont load
require("config/nvimTree").config() -- nvimtree
require("colorizer").setup()
require("config/treesitter-nvim").config() -- treesitter
require("config/nvim-lspconfig").config() -- lsp
require("config/gitsigns-nvim").config() -- gitsigns
require("nvim_comment").setup() --comment
require("config/dashboard").config() -- dashboard
require("neoscroll").setup() -- neoscroll
--require("config/misc-utils").blankline() -- blankline
display = {
  border = {"┌", "─", "┐", "│", "┘", "─", "└", "│"}
}

--colorscheme
g.theme = "onedark"
local base16 = require "base16"
base16(base16.themes[g.theme], true)

require "config/highlights"
require "config/mappings"
require "config/file-icons"
require "config/statusline"

-- TODO > not en editor command
-- vim.cmd("ColorizerReloadAllBuffers")
-- hide line numbers , statusline in specific buffers!
vim.api.nvim_exec(
    [[
   au BufEnter term://* setlocal nonumber
   au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
   au BufEnter term://* set laststatus=0 
]],
    false
)

EOF
" }}
