set nocompatible " running vim not vi
" TODO: have a look at these crazy things:
"
" Source the vimrc file after saving it. This way, you don't have to
"reload Vim to see the changes.
"if has("autocmd")
" augroup myvimrchooks
"   au!
"     autocmd bufwritepost .vimrc source ~/.vimrc
"      augroup END
"   endif
" ---------
" Set up an HTML5 template for all new .html files
""autocmd BufNewFile * silent! 0r $VIMHOME/templates/%:e.tpl


" some flags. keep em !sort-ed (V21j:!sort)
set background=dark " dark background, helps a lot
set backspace=2 " better backspace
set cursorline " visual help
set encoding=utf-8 " fixed encoding
set fileencoding=utf-8 " fixed encoding
set hlsearch " highlight search
set ignorecase " ignore case on search
set incsearch " search as you type
set laststatus=2 " better status line
set number " line numbers
set paste " sane copy paste
set shiftwidth=2 " sane indent width
set showcmd " show command in lower right corner
set smartcase " if typing upcase letters in search, only search for exact matches
set smarttab " less tab key hitting
set splitbelow " default split position sucks
set splitright " this position sucks too
set tabstop=2 " sane tab width
set wildmenu " a lot better command-line completion
set wildmode=list:longest " even better command-line completion
set wrap " wrap terribly long lines

let mapleader="," " set the leader to comma

" ===============
" keymappings
" ===============

nnoremap <leader>u :GundoToggle<CR>
" ,V and ,v for opening and reloading the vimrc
map <leader>V :vsplit ~/.vimrc<CR><C-W>_
map <silent> <leader>v :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
" map jj to escape key in insert mode
imap jj <esc>
" move vertically by displayed line instead of real line
nnoremap j gj
nnoremap k gk
" toggle relative line number
nnoremap <leader>r :set invrelativenumber<CR>

" ===============
" automagic stuff
" ===============

" automatically remove whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" ===============
" plugins
" ===============

" automagically install plugin management  and all plugins if they are not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" file explorer
Plug 'scrooloose/nerdtree'
" xml editing made easyer
" Plug 'sukima/xmledit'
" json helper
Plug 'jakar/vim-json'
" undo helper
Plug 'sjl/gundo.vim'

" completion framework -> requires running python
" TODO: automatically run the python script
Plug 'ycm-core/YouCompleteMe'

" snippets engine
" Plug 'SirVer/ultisnips'

" actual snippets
Plug 'honza/vim-snippets'

call plug#end()
" non auto installed plugins go here. stuff that's language centered etc

syntax on " enable syntax coloring
filetype on " enable filetype detection
filetype indent on " indent based on filetype
"filetype plugin on " find filtypes by plugin

" ===============
" UI
" ===============

" improve autocomplete menu color
highlight Pmenu ctermbg=grey

" ===============
" NERDtree
" ===============

" show hidden files
let NERDTreeShowHidden=1
