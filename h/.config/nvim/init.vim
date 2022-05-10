" some flags. keep em !sort-ed (V20j:!sort)
let &showbreak = '-> ' " linebreak identifier
set breakindent " indent wrapped/broken lines
set breakindentopt=min:50,shift:2,sbr " have a minimum of 50 chars readable while wrapping, shift the wrap by 2 and show the break sign in the line number display
set conceallevel=2 " Concealing
set copyindent " use the same characters for indenting (let's hope this helps with yaml)
set cursorline " visual help
set hidden " recommended by coc
set ignorecase " ignore case on search
set linebreak " don't randomly break in the middle of the line, use 'breakat' instead
set number " line numbers
set shiftwidth=2 " sane indent width
set smartcase " if typing upcase letters in search, only search for exact matches
set smartindent " use nice indenting
set splitbelow " default split position sucks
set splitright " this position sucks too
set tabstop=2 " sane tab width
set updatetime=100 " time untill swp is saved and git gutter updates
set wildignore+=/**/*.class
set wildmenu " a lot better command-line completion
set wildmode=list:longest " even better command-line completion
set wrap " wrap terribly long lines
"
" :help option-list
" TODO read all after this:
" 'completeopt'		'cot'		 options for Insert mode completion

" keymappings
" ===============

" set the leader to comma
let mapleader=","

" ,V and ,v for opening and reloading the vimrc
nnoremap <leader>V :vsplit $MYVIMRC<CR><C-W>
nnoremap <silent> <leader>v :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

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
let $FZF_DEFAULT_OPTS= '--query="!bin/ !target/ !build/ !node_modules/ "'
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
inoremap <silent><expr><c-space> coc#refresh()

" because I can
inoremap <leader>F (╯°□°)╯︵ ┻━┻

" plugins
" ===============

" automagically install plugin management and all plugins if they are not present
if empty(glob(stdpath('data') . '/site/autoload/plug.vim'))
	execute '!curl -fLo ' . stdpath('data') . '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" git commands
nnoremap <leader>ga :Git add -p<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gs :Git status<CR>
nnoremap <leader>gp :Git push<CR>

call plug#begin(stdpath('data') . '/plugged')
" github codepilot
Plug 'github/copilot.vim', { 'do':'Copilot setup' }

" file explorer
Plug 'scrooloose/nerdtree'
" json helper
Plug 'jakar/vim-json'

" conquer of completion
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do':':CocInstall coc-java coc-yaml coc-json coc-html coc-xml coc-snippets coc-tsserver coc-angular'}

" comment highlighting
" Plug 'jbgutierrez/vim-better-comments'

" nvim in my browser <3
Plug 'glacambre/firenvim', {'do': 'firenvim#install(0)'}

" vim show changed lines
Plug 'airblade/vim-gitgutter'

" well, fugitive. huge git plugin
Plug 'tpope/vim-fugitive'

" markdown formatting
" tabular has to come first
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" disable the automatic folding (it breaks things)
let g:vim_markdown_folding_disabled = 1

" required for diffview
Plug 'nvim-lua/plenary.nvim'
" icons for diffview
Plug 'kyazdani42/nvim-web-devicons'
" diffview
Plug 'sindrets/diffview.nvim'

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
highlight Folded ctermbg=magenta ctermfg=lightgrey

" firenvim
" ===============
if exists('g:started_by_firenvim')
	set laststatus=0
	autocmd InsertLeave * ++nested write
	"autocmd TextChanged * ++nested write
	"autocmd TextChangedI * ++nested write
end

" NERDtree
" ===============

" show hidden files
let NERDTreeShowHidden=1

" automagic stuff
" ===============

" remove whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" open nerdtree by default instead of empty buffer
autocmd StdinReadPre * let s:std_in=1
if !exists('g:started_by_firenvim')
	autocmd VimEnter * NERDTree | wincmd p
end

" close nerd tree if it's the last buffer
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" conquer of completion functions
" ===============

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]	=~# '\s'
endfunction


function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocActionAsync('doHover')
	endif
endfunction

