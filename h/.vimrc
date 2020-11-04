" credits {{{
" ===============
" Ben Jackson (@puremourning) and Boris Staletic (@bstaletic) helped me out big time here.
" Without them I would have never figured out that some of the flags I set are
" causing a lot more trouble than one would expect.
" Like setting nocompatible or paste
"}}}

" settings and flags {{{
" some flags. keep em !sort-ed (V22j:!sort)
set background=dark " dark background, helps a lot
set backspace=2 " better backspace
set conceallevel=2 " Concealing
set cursorline " visual help
set encoding=utf-8 " fixed encoding
set fileencoding=utf-8 " fixed encoding
set hlsearch " highlight search
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
"}}}

" keymappings {{{
" ===============

let mapleader="," " set the leader to comma
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

" go to definition etc.
nmap <leader>d <Plug>(coc-definition)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>r <Plug>(coc-references)
map <leader>R <Plug>(coc-rename)
nmap <leader>f :CocFix<CR>
" because I can
imap <leader>F (╯°□°)╯︵ ┻━┻
nmap <leader>F :NERDTreeFind<CR>

" fuzzy file open with ctrlp
let $FZF_DEFAULT_OPTS= '--query="!bin !target"'
nmap <leader>o :FZF<CR>

" plugins {{{
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
" xml editing made easyer
Plug 'sukima/xmledit'
" json helper
Plug 'jakar/vim-json'

" completion framework -> requires running python
"Plug 'ycm-core/YouCompleteMe', {'do': './install.sh --java'}

" conquer of completion
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do':':CocInstall coc-java coc-yaml coc-json coc-html coc-xml'}

" plugin library from google
" needed for google/vim-codefmt
Plug 'google/vim-maktaba'

" code formatting by google
Plug 'google/vim-codefmt', {'do': 'curl -L https://github.com/google/google-java-format/releases/download/google-java-format-1.8/google-java-format-1.8-all-deps.jar -o /home/meredrica/.vim/plugged/vim-codefmt/format.jar'}
"
" needed for google/vim-codefmt
Plug 'google/vim-glaive'

" comment highlighting
Plug 'jbgutierrez/vim-better-comments'

" vim show changed lines
Plug 'airblade/vim-gitgutter'

" well, fugitive. huge git plugin
Plug 'tpope/vim-fugitive'

call plug#end()
call glaive#Install()

"Glaive formatter setup for java. jar file is here https://github.com/google/google-java-format
Glaive codefmt google_java_executable="java -jar /home/meredrica/.vim/plugged/vim-codefmt/format.jar"

syntax on " enable syntax coloring
filetype on " enable filetype detection
filetype indent on " indent based on filetype
filetype plugin on " find filtypes by plugin
"}}}

" UI {{{
" ===============

" improve autocomplete menu color
" find settings with :highlight
highlight Pmenu ctermbg=grey
"}}}

" NERDtree {{{
" ===============

" show hidden files
let NERDTreeShowHidden=1
"}}}

" automagic stuff {{{
" ===============

" automatically remove whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" ===============
" conquer of completion specific
" ===============
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-@> coc#refresh()

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction
"}}}
