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


" set flags sorted with: !sort (visually selected)
set background=dark " dark background, helps a lot
set backspace=2 " better backspace
set cursorline " visual help
set encoding=utf-8 " fixed encoding
set fileencoding=utf-8 " fixed encoding
"set go= " no gui options
set hlsearch " highlight search
set ignorecase " ignore case on search
set incsearch " search as you type
set laststatus=2 " better status line
set number " line numbers
set shiftwidth=2 " sane indent width
set smarttab " less tab key hitting
set showcmd " show command in lower right corner
set tabstop=2 " sane tab width
set wrap " wrap terribly long lines
set smartcase " if typing upcase letters in search, only search for exact matches
set rtp+=~/.vim/bundle/vundle/ " Vundle runtime path fixes and hook
set wildmenu " a lot better command-line completion
set wildmode=list:longest " even better command-line completion

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
" vundle
" ===============
" I prefer github over vimscripts

" disable filetype detection until vundle is done
filetype off

" automagically install vundle and all bundles if they are not present
" this method is from http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
		echo "Installing Vundle.."
		echo ""
		silent !mkdir -p ~/.vim/bundle
		silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
		let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" vundle itself
Bundle 'gmarik/vundle'
" tab completion
Bundle 'SuperTab-continued'
" file explorer
Bundle 'scrooloose/nerdtree'
" xml editing made easyer
Bundle 'sukima/xmledit'
" json helper
Bundle 'jakar/vim-json'
" last part of auto install
if iCanHazVundle == 0
		echo "Installing Bundles, please ignore key map error messages"
		echo ""
		:BundleInstall
endif

" non auto installed vundles go here. stuff that's language centered etc
" LaTeX
" my own LaTeX hax
Bundle 'meredrica/vim-latex-german'
" latex helper
Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'

" HTML et all
" coffeescript
Bundle 'kchmck/vim-coffee-script'

" ruby etc
" ruby support
Bundle 'vim-ruby/vim-ruby'
" automatically insert end, endif etc for ruby
Bundle 'tpope/vim-endwise'

syntax on " enable syntax coloring
filetype on " enable filetype detection
filetype indent on " indent based on filetype
filetype plugin on " find filtypes by plugin

" ===============
" UI
" ===============

" improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" ===============
" NERDtree
" ===============

" show hidden files
let NERDTreeShowHidden=1

" ===============
" ruby flags
" ===============
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
compiler ruby " enable compiler support for ruby
