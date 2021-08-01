" settings and flags
" some flags. keep em !sort-ed (V23j:!sort)
set background=dark " dark background, helps a lot
set backspace=2 " better backspace
set conceallevel=2 " Concealing
set cursorline " visual help
set encoding=utf-8 " fixed encoding
set fileencoding=utf-8 " fixed encoding
set hlsearch " highlight search
set hidden " recommended by coc
set ignorecase " ignore case on search
set incsearch " search as you type
set laststatus=2 " better status line
set number " line numbers
set shiftwidth=2 " sane indent width
set showcmd " show command in lower right corner
set smartcase " if typing upcase letters in search, only search for exact matches
set smartindent " use nice indenting
set smarttab " less tab key hitting
set splitbelow " default split position sucks
set splitright " this position sucks too
set tabstop=2 " sane tab width
set updatetime=100 " time untill swp is saved and git gutter updates
set wildignore+=/**/*.class
set wildmenu " a lot better command-line completion
set wildmode=list:longest " even better command-line completion
set wrap " wrap terribly long lines


" keymappings
" ===============

" set the leader to comma
let mapleader=","

" ,V and ,v for opening and reloading the vimrc
nnoremap <leader>V :vsplit ~/.vimrc<CR><C-W>
nnoremap <silent> <leader>v :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" move vertically by displayed line instead of real line
nnoremap j gj
nnoremap k gk

" toggle relative line number
nnoremap <leader>rn :set invrelativenumber<CR>

" copy to clipboard
vnoremap <leader>c "+y<CR>

" find current file in nerdtree
noremap <leader>F :NERDTreeFind<CR>

" fuzzy file open
let $FZF_DEFAULT_OPTS= '--query="!bin/ !target/ !build/ "'
nnoremap <leader>o :FZF<CR>

" go to definition etc.
nmap <leader>d <Plug>(coc-definition)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>r <Plug>(coc-references)
nmap <leader>R <Plug>(coc-rename)
nmap <leader>f :CocFix<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" map jj to escape key in insert mode
inoremap jj <esc>

" completion
imap <leader>c <Plug>(coc-snippets-expand-jump)

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-@> coc#refresh()

" because I can
inoremap <leader>F (╯°□°)╯︵ ┻━┻

autocmd FileType todo let maplocalleader = ","

" plugins
" ===============

" automagically install plugin management and all plugins if they are not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" file explorer
Plug 'scrooloose/nerdtree'
" json helper
Plug 'jakar/vim-json'

" conquer of completion
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do':':CocInstall coc-java coc-yaml coc-json coc-html coc-xml coc-snippets coc-kotlin'}

" plugin library from google
" needed for google/vim-codefmt
Plug 'google/vim-maktaba'

" comment highlighting
Plug 'jbgutierrez/vim-better-comments'

" vim show changed lines
Plug 'airblade/vim-gitgutter'

" well, fugitive. huge git plugin
Plug 'tpope/vim-fugitive'

" markdown formatting
" tabular has to come first
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" kotlin
Plug 'udalov/kotlin-vim'

" todo.txt
Plug 'freitass/todo.txt-vim'

" folding
Plug 'pseewald/anyfold'
" auto fold java
autocmd Filetype java AnyFoldActivate
let g:anyfold_identify_comments=2 " keep comments open


call plug#end()

syntax on " enable syntax coloring
filetype on " enable filetype detection
filetype indent on " indent based on filetype
filetype plugin on " find filtypes by plugin


" UI
" ===============

" improve autocomplete menu color
" find settings with :highlight
highlight Pmenu ctermbg=black ctermfg=white
highlight PmenuSel ctermfg=yellow

" NERDtree
" ===============

" show hidden files
let NERDTreeShowHidden=1


" automagic stuff
" ===============

" autofold this file with markers
autocmd BufEnter .vimrc setlocal foldmethod=marker

" fold java with level 1
autocmd FileType java setlocal foldlevel=1

" remove whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" open nerdtree by default instead of empty buffer
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif

" close nerd tree if it's the last buffer
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif



" conquer of completion functions
" ===============

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

