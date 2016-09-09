" setup the pathogen_disabled variable so we can disable certain plugins
" depending on if we're in a GUI or not
let g:pathogen_disabled = []

if has('gui_running')
	" bump our gui font
	set guifont=Ubuntu\ Mono\ 13,DejaVu\ Sans\ Mono\ 13,Monaco:h13
endif

if argc() == 0
	" Show NERDTree on startup in each tab if we're started without
	" any arguments
	let g:nerdtree_tabs_open_on_console_startup=1
endif

" Show line numbers
set number

" Let pathogen manage our plugins
execute pathogen#infect()

" Dark Solarized
set background=dark
colorscheme solarized

filetype plugin on
filetype indent on
syntax enable
set ai

" show trailing whitespace
match ErrorMsg '\s\+$'

set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
set laststatus=2

set modeline modelines=2

autocmd BufRead,BufNewFile BUCK set ft=python
autocmd BufRead,BufNewFile *.pp set ft=puppet
autocmd BufRead,BufNewFile *.tf set ft=terraform

autocmd FileType c,cpp set ts=4 sw=4 et sts=4
autocmd FileType html,js,css,less,scss,mustache,tpl,xml set ts=4 sw=4 et sts=4
autocmd FileType java set ts=4 sw=4 et sts=4
autocmd FileType json,yaml set ts=2 sw=2 et sts=2
autocmd FileType python set ts=4 sw=4 et sts=4 tw=120 wrap
autocmd FileType go set ts=4 sw=4 ai
autocmd FileType rst set ts=4 sw=4 et sts=4 spell tw=120 wrap
autocmd FileType terraform set ts=4 sw=4 et sts=4 ai

" check the file when we enter a buffer/window
autocmd BufWinEnter * checktime

" prefer pylint over flake8
let g:syntastic_python_checkers = ['pylint']

" source our global vim overrides if they exist
if filereadable(glob("~/.vimrc.local"))
	source ~/.vimrc.local
endif

" source our per-project overrides if they exist
if filereadable('.vimrc.local')
	source .vimrc.local
endif

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
