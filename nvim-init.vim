" ensure we can backspace over all situations
set backspace=indent,eol,start

" UTF-8 encoding
set encoding=utf-8

" Python support
let g:python_host_prog = '/home/evan/.virtualenvs/neovim-py2/bin/python'
let g:python3_host_prog = '/home/evan/.virtualenvs/neovim-py3/bin/python'

" Plugins
call plug#begin()
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeTabsToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on':  'NERDTreeTabsToggle' }
	
Plug 'junegunn/fzf'

Plug 'iCyMind/NeoSolarized'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'sheerun/vim-polyglot'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'psf/black', { 'tag': '19.10b0', 'do': ':BlackUpgrade', 'for': 'python' }
Plug 'deoplete-plugins/deoplete-jedi', { 'for': 'python' }
Plug 'davidhalter/jedi-vim', { 'for': 'python' }

Plug 'fatih/vim-go', { 'tag': '*', 'for': 'go' }
call plug#end()

" Airline
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

" Use Jedi for Python, but let deoplete deal with auto completion
let g:jedi#completions_enabled = 0
let g:jedi#use_tabs_not_buffers = 1

" Use deoplete for code completion
let g:deoplete#enable_at_startup = 1

" Set omni mode for go
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" Map fzf to leader+f
map <Leader>f :FZF<CR>

" Map nerd tree to leader+q
map <Leader>q :NERDTreeTabsToggle<CR>

" We want to see hidden files
let NERDTreeShowHidden=1

" We don't want to see compiled Python files
let NERDTreeIgnore=['\.pyc$', '\~$']

" NERDTree setting defaults to work around http://github.com/scrooloose/nerdtree/issues/489
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeGlyphReadOnly = "RO"

" Show line numbers
set number

syntax on
filetype on
filetype plugin indent on

" Enable auto-indent
set ai

autocmd FileType python set et ts=4 sw=4 sts=4 tw=90 wrap

set background=dark
colorscheme NeoSolarized

" Work with hidden buffers
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" check the file when we enter a buffer/window
autocmd BufWinEnter * checktime

" Blackify python files on write
autocmd BufWritePre *.py execute ':Black'
