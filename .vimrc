set encoding=utf-8
scriptencoding utf-8
filetype plugin indent on     " required!

if has('gui_running')
    set guioptions-=T  "no toolbars
    set guioptions-=m  "or menu
    set guioptions-=r  "or scrollbars
    set guioptions-=l
    set guioptions-=R
    set guioptions-=L
    set guioptions-=b
    set guioptions-=h
    set guioptions-=e  "I dont like the gui tabs, use ascii
    set guifont=EssentialPragmataPro\ Nerd\ Font\ Mono\ 10
endif

"use vim as a man pager
let $PAGER=''

set t_Co=256                        "let terminal vim use 256 colors

let base16colorspace=256  " Access colors present in 256 colorspace

command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -

syntax enable

set exrc                            "Load .vimrc on a per-project basis
set secure                          "prevent autocmd, shell, and write commands unless vimrc is owned by you
set spell spelllang=en_us
set title                           "set xterm title to vim title
set titleold=""
set tabstop=4                       "a tab is four spaces.
set shiftwidth=4                    "four spaces for autoindenting
set softtabstop=4
set expandtab                       "Insert spaces instead of tabs
set shiftround                      "use multiple of shiftwidth for indenting
set smartindent                     "Seems to do a decent job with indenting
set scrolloff=2                     "always show lines of code above/below cursor
set hidden                          "Dont delete buffers, just hide them. Lets us :e another file without having to s
set wildmenu                        "improve auto complete menu
set wildmode=list:longest           "when tab is pressed, show a list similar to ls
set cursorline                      "highlight the line the cursor is on
set cursorcolumn                    "highlight the column the cursor is on
set ttyfast                         "it is fast, this aint no modem
set ruler
set nofoldenable                    "I dont like folding text, so disable it everywhere
set diffopt=filler,context:1000000 " filler is default and inserts empty lines for sync
set backspace=indent,eol,start      "Backspace over everything
set laststatus=2                    "always show status bar
set number
set showmatch                       "highligh matching [{()}]

set undodir=~/.vim/undo
set undofile                        "save undo tree when file is closed
set backupdir=~/.vim/backup
set backup                          "backup files should be kept out of the working dir
set directory=~/.vim/tmp

set viminfo+=n~/.vim/viminfo        "get this file out of home

"tame searching
set ignorecase                      "better searching:
set smartcase                       "ignore case in a search until there is some capitalization
set gdefault                        "apply replaces globally, do have to add g to them anymore
set incsearch                       "Jump to the first instance as you type the search term
set showmatch                       "always show matching ()'s
set hlsearch                        "Highlight all of the search terms

"setup line wrapping
set nowrap
set textwidth=119
set formatoptions=qrn1
set colorcolumn=120

"show unwanted whitespace
set list
set list listchars=tab:»·,trail:·,extends:…
set showbreak=\ \ …\ 
set background=dark
set history=1000                    "Remember a ton of commands
set mouse=a                         "Allow for better mouse interaction
set ttymouse=xterm2



" make portmaps and other things indent using shiftwidth value and not location of ( + shiftwidth
let g:vhdl_indent_genportmap = 0

" change leader to space, nicer to type. You loose some sort of 'move to next char' command. 
let g:mapleader = "\<Space>"

nmap <silent> <leader>t :TagbarToggle<CR>
nmap <silent> <leader>g :GundoToggle<CR>
nmap <silent> <Leader>a :FSHere<cr>
nnoremap <leader>o :CtrlP<cr>

" use leader {y|d|p} for interacting with the system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" enter visual line mode easier
nmap <leader><leader><leader> V

" typing jj in insert mode gets you out.
inoremap jj <Esc>

" vim training wheels: dont allow arrow keys!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" run make silently and open the quickfix window in case of errors
nnoremap <leader>m :silent make\|redraw!\|cc<CR>

" fix direction keys for line wrap, other wise they jump over wrapped lines
nnoremap j gj
nnoremap k gk

"remap f1. I'll type :help when I want it
map <F1> <ESC>
imap <F1> <ESC>

"keep cursor in the middle of the screen while keyscrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

"move between windows a little easier
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" I have never intentionally entered the mode that q: gives.
map q: :q
nnoremap Q <nop>

" make it a little harder to start recording a macro. I accidently record more than not
noremap <Leader>q q
noremap q <nop>

" Map alt click on an item to jump to definition. Uses tjump for ambiguous tags.
map <A-2-LeftMouse> :exe "tjump ". expand("<cword>")<CR>


" :wq when I meant :w. Nudges towards using :x
cabbrev wq w

" :W isnt a command, and I usually intend on :w
cabbrev W w

" :X is a strange crypto thing that I dont care about, intention is :x
cabbrev X x

" Allow saving of files as sudo when I forgot to start vim using sudo.
cabbrev w!! w !sudo tee > /dev/null %

" Make it a little easier to get into VimShell
cabbrev shell VimShell

augroup allfiles
    "Wipe out the allfiles group for when we reload the vimrc. Otherwise we just keep reattaching commands
    autocmd!
    "Customize python settings
    autocmd bufreadpre *.py setlocal textwidth=99
    autocmd bufreadpre *.py setlocal colorcolumn=100

    "Change lua tabstops to be more lua-esque
    autocmd FileType lua setl sw=2 sts=2 et

    "Close the preview window if it is open
    autocmd InsertLeave * pclose

    "Cleanup fugitive buffers automatically
    autocmd BufReadPost fugitive://* set bufhidden=delete

    " cursorline on active windows only
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline | setlocal cursorcolumn
    autocmd WinLeave * setlocal nocursorline | setlocal nocursorcolumn
augroup END



" run plugged
call plug#begin('~/.vim/plugged')

let g:ale_emit_conflict_warnings = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins that add new windows
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"fancypants status line
Plug 'itchyny/lightline.vim'
let g:lightline = {
    \ 'component': {
    \   'readonly': "%{&readonly?'⭤':''}",
    \ },
    \ 'component_function': {
    \   'filename': 'LightlineFilename',
    \ },
    \ }

function! LightlineFilename()
    let l:short_filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
    let l:med_filename = expand('%:t') !=# '' ? fnamemodify(expand('%:p'), ':~:.') : '[No Name]'
    let l:full_filename = expand('%:t') !=# '' ? fnamemodify(expand('%:p'), ':~') : '[No Name]'

    let l:max_len = 120
    let l:full_len = len(l:full_filename)
    let l:med_len = len(l:med_filename)

    let l:use_short = l:full_len > l:max_len && l:med_len > l:max_len
    let l:use_med = l:full_len > l:max_len && l:med_len <= l:max_len

    return l:use_short ? l:short_filename : l:use_med ? l:med_filename : l:full_filename
endfunction

"adds a window that shows all of the functions in the current file
Plug 'majutsushi/tagbar'

"visual undo tree. nice for when you need to go back to a branch
Plug 'sjl/gundo.vim'

"ctrl-p for go to anything
Plug 'kien/ctrlp.vim'
" make CtrlP use ag and not cache
let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = '0'
if executable('ag')
    set  grepprg=ag\ --nogroup\ --nocolor
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

"provides hg/git change status in the left gutter
Plug 'mhinz/vim-signify'

"vim front end for ack, with support for ag backend
Plug 'mileszs/ack.vim'
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

"better buffer management
Plug 'jlanzarotta/bufexplorer'

"display marks
Plug 'kshenoy/vim-signature'

"Alternative to netrw, which is slow and buggy
Plug 'jeetsukumaran/vim-filebeagle'

"Git wrapper for doing git things on files in vim
Plug 'tpope/vim-fugitive'
command! Greview :Git! diff --staged

"automatically display markdown view when editing md files
Plug 'suan/vim-instant-markdown'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Intellisense, autocompletion, and linting
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"Syntax linting engine
Plug 'vim-syntastic/syntastic', {'for': ['c', 'cpp', 'vhdl']}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_ignore_files = ['\m^/usr/include/']
let g:syntastic_cpp_checkers = ['clang_check']
let g:syntastic_c_checkers = ['gcc']
let g:syntastic_c_compiler_options = ''
let g:syntastic_c_no_default_include_dirs = 1
let g:syntastic_vhdl_checkers = ['vimhdl']
let g:syntastic_mode_map = { 'passive_filetypes': ['python', 'vim', 'rust', 'clojure', 'elixir'] }

"Very simple completer that basically runs through vim's default completion engine
Plug 'ajh17/VimCompletesMe'
set completeopt+=menuone,longest,preview
"Make up/down/cr map to the (oddly) more useful ctrl-n, ctrl-p, ctrl-y, ctrl-e
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"

"Automatic tag management
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_ctags_exclude = ['.notags']

"Better local vimrc. It'll find it at .git level
Plug 'krisajenkins/vim-projectlocal'

"Async linting engine
Plug 'w0rp/ale', {'for': ['python', 'vim', 'rust', 'clojure', 'zsh', 'bash', 'elixir']}
let g:ale_linters = {'c': [], 'cpp': [],}

"Adhere to linux coding style guidelines
Plug 'vivien/vim-linux-coding-style'
let g:linuxsty_patterns = ["/home/adam/projects/idexx/acadia/kernel_modules/"]
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Plugins that add keyboard commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""

"replace {motion} with a register. Faster than typing '"_c[motion]^r"'
Plug 'vim-scripts/ReplaceWithRegister'

"repeated v's expand out the visually selected region
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"nice motion plugin, relieves 'w' spam, lighter weight than easymotion
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1

"better file switching
Plug 'derekwyatt/vim-fswitch'
augroup mycppfiles
    au!
    au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/headers/cpp/,ifrel:|/include/|../src|,./'
    au BufEnter *.cpp let b:fswitchlocs = 'reg:/src/include/,reg:/cpp/headers/,ifrel:|/src/|../include|,./'
augroup END


"Add numerous [ and ] bindings for naviation
Plug 'tpope/vim-unimpaired'

"Add Linux command line tools to vim directly, :SudoWrite, :Find are especially nice
Plug 'tpope/vim-eunuch'

"Add toggle for location and quickfix windows
Plug 'Valloric/ListToggle'
let g:lt_height = 10
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>c'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Syntax Highlighting
"""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'NLKNguyen/c-syntax.vim', {'for': ['c', 'cpp']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
let g:cpp_class_scope_highlight = 1
Plug 'adamatom/vim-pasm'
Plug 'hdima/python-syntax', {'for': 'python'}
let g:python_highlight_all = 1
Plug 'fatih/vim-go', {'for': 'go' }
Plug 'wlangstroth/vim-racket', {'for': ['scheme', 'racket']}
Plug 'tpope/vim-fireplace', {'for' : 'clojure' }
Plug 'aklt/plantuml-syntax'
Plug 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1
Plug 'elixir-editors/vim-elixir'
Plug 'suoto/vim-hdl'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" omni completers
"""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'davidhalter/jedi-vim', {'for' : 'python'}
let g:jedi#popup_on_dot = 0
let g:jedi#goto_command = "gD"
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>jn"
let g:jedi#completions_command = ""
let g:jedi#rename_command = ""
Plug 'slashmili/alchemist.vim', {'for' : 'elixir'}
Plug 'justmao945/vim-clang', {'for' : ['cpp', 'c']}
Plug 'racer-rust/vim-racer', {'for' : 'rust'}

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" color schemes
"""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'adamatom/papercolor-theme'
Plug 'chriskempson/base16-vim'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" other
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim HardTime
Plug 'takac/vim-hardtime'
let g:hardtime_default_on = 0
let g:hardtime_ignore_quickfix = 1
let g:hardtime_maxcount = 2
let g:hardtime_allow_different_key = 1
let g:list_of_normal_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_visual_keys = ["h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_insert_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_disabled_keys = []
let g:hardtime_ignore_buffer_patterns = [ ".*BufExpl.*" ]

call plug#end()

"colorscheme PaperColor
colorscheme base16-irblack
highlight Cursor guifg=yellow guibg=red
