" bump our gui font
if has('gui_running')
    set guifont=Hack:h13,Ubuntu\ Mono\ 13,DejaVu\ Sans\ Mono\ 13,Monaco:h13
endif

" setup the pathogen_disabled variable so we can disable certain plugins
" depending on if we're in a GUI or not
let g:pathogen_disabled = []

" Let pathogen manage our plugins
execute pathogen#infect()

" Map nerd tree to leader+q
map <Leader>q :NERDTreeTabsToggle<CR>

" We want to see hidden files
let NERDTreeShowHidden=1

" ensure we can backspace over all situations
set backspace=indent,eol,start

" Show line numbers
set number

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

autocmd BufRead,BufNewFile *.tf set ft=terraform

autocmd FileType c,cpp set ts=4 sw=4 et sts=4
autocmd FileType html,css,less,scss,mustache,tpl,xml set ts=4 sw=4 et sts=4
autocmd FileType java,groovy set ts=4 sw=4 et sts=4
autocmd FileType yaml set ts=4 sw=4 et sts=4
autocmd FileType json set ts=2 sw=2 et sts=2
autocmd FileType ruby set ts=2 sw=2 et sts=2
autocmd FileType python set ts=4 sw=4 et sts=4 tw=120 wrap
autocmd FileType lua set ts=4 sw=4 et sts=4 tw=120 wrap
autocmd FileType go set ts=4 sw=4 ai
autocmd FileType rst set ts=4 sw=4 et sts=4 spell tw=120 wrap
autocmd FileType terraform set ts=4 sw=4 et sts=4 ai
autocmd FileType javascript,js set ts=2 sw=2 et sts=2 ai

" check the file when we enter a buffer/window
autocmd BufWinEnter * checktime

" prefer pylint over flake8
let g:syntastic_python_checkers = ['pylint']

" source our global vim overrides if they exist
if filereadable(glob("~/.vimrc.local"))
	source ~/.vimrc.local
endif

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" configure command-T
let g:CommandTFileScanner = "find"
let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTSmartCase = 1

" source our per-project overrides if they exist
if filereadable('.vimrc.local')
	source .vimrc.local
endif

let g:prettier#config#parser = 'babylon'

" Setup ack.vim to use ag for searching
let g:ackprg = 'ag --vimgrep --smart-case'
nnoremap <Leader>a :Ack!<Space>
