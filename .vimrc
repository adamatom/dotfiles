set nocompatible              " be iMproved
filetype off                  " required!
filetype plugin indent on     " required!

if has("gui_running")
    set guioptions-=T  "no toolbars
    set guioptions-=m  "or menu
    set guioptions-=r  "or scrollbars
    set guioptions-=l
    set guioptions-=R
    set guioptions-=L
    set guioptions-=b
    set guioptions-=h
    set guioptions-=e  "I dont like the gui tabs, use ascii
    set guifont=Input\ Mono\ Condensed\ Regular\ 10
endif

    "use vim as a man pager
let $PAGER=''

set t_Co=256                        "let terminal vim use 256 colors
"set termguicolors

command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -

" run plugged
call plug#begin('~/.vim/plugged')

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins that add new windows
"""""""""""""""""""""""""""""""""""""""""""""""""""""
    "fancypants status line
Plug 'itchyny/lightline.vim'
  let g:lightline = { 'component': { 'readonly': '%{&readonly?"⭤":""}', } }

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

    "vim front end for 'the silver searcher'
Plug 'mileszs/ack.vim'
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif

    "better buffer management
Plug 'jlanzarotta/bufexplorer'

    "display marks
Plug 'kshenoy/vim-signature'

    "file tree because netrw is bad
Plug 'scrooloose/nerdtree'
  let g:NERDTreeHijackNetrw=1
  let g:NERDTreeMapUpdirKeepOpen="-"

    "netrw file explorer via '-' key
Plug 'tpope/vim-vinegar'

    "automatically display markdown view when editing md files
Plug 'suan/vim-instant-markdown'

    "A shell for simple stuff
Plug 'shougo/vimshell.vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Intellisense, autocompletion, and linting
"""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Syntax linting engine
Plug 'vim-syntastic/syntastic'
  let g:syntastic_clang_check_config_file = ".clang_complete"
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 0
  let g:syntastic_check_on_wq = 0
  let g:syntastic_ignore_files = ['\m^/usr/include/']
  let g:syntastic_cpp_checkers = ["clang_check"]
  let g:syntastic_c_checkers = ["gcc"]


    "lightweight autocomplete via chaining fallbacks so you dont have to remember ctrl-x ctrl-...
Plug 'lifepillar/vim-mucomplete'
  inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
  inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
  inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")
  set shortmess+=c
  set completeopt-=preview
  set completeopt+=longest,menuone,noinsert,noselect
  let g:mucomplete#enable_auto_at_startup = 1
  "let g:mucomplete#no_mappings = 0
  let g:mucomplete#chains = {'vim': ['file', 'cmd', 'keyn'], 
        \    'default': ['omni','file', 'keyn', 'dict'],
        \    'cpp': ['omni', 'file', 'keyp', 'incl', 'dict'],
        \    'c': ['omni', 'file', 'keyp', 'incl', 'dict'],
        \    'text': ['file', 'keyn', 'dict'],
        \    'lua': ['file', 'keyn', 'dict']
        \  }

  let g:mucomplete#can_complete = {}
  let g:mucomplete#can_complete.default = {
        \   'file': { _ -> 1 }
        \   }

    "Make up/down/cr map to the (oddly) more useful ctrl-n, ctrl-p, ctrl-y, ctrl-e
  inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
  inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"

    "Python omnifunc completer
Plug 'davidhalter/jedi-vim'

    "C/C++ omnifunc completer
Plug 'Rip-Rip/clang_complete', {'for': ['c', 'cpp']}
  let g:clang_user_options = '-std=c++14'
  let g:clang_complete_auto = 1

    "Automatic tag management
Plug 'ludovicchabant/vim-gutentags'
  let g:gutentags_ctags_tagfile = ".tags"

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Plugins that add keyboard commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""

    "replace {motion} with a register. Faster than typing '"_c[motion]^r"'
Plug 'vim-scripts/ReplaceWithRegister'

    "repeated v's expand out the visually selected region
Plug 'terryma/vim-expand-region'
  vmap v <Plug>(expand_region_expand)
  vmap <C-v> <Plug>(expand_region_shrink)

    "nice motion plugin, relieves 'w' spam
Plug 'Lokaltog/vim-easymotion'

    "better file switching
Plug 'derekwyatt/vim-fswitch'
 augroup mycppfiles
   au!
   au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/headers/cpp/,ifrel:|/include/|../src|,./'
   au BufEnter *.cpp let b:fswitchlocs = 'reg:/src/include/,reg:/cpp/headers/,ifrel:|/src/|../include|,./'
 augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Syntax Highlighting
"""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'NLKNguyen/c-syntax.vim', {'for': ['c', 'cpp']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
    let g:cpp_class_scope_highlight = 1
Plug 'adamatom/vim-pasm'
Plug 'hdima/python-syntax', {'for': 'python'}
    let python_highlight_all = 1
Plug 'fatih/vim-go', {'for': 'go' }
Plug 'wlangstroth/vim-racket', {'for': ['scheme', 'racket']}
Plug 'tpope/vim-fireplace', {'for' : 'clojure' }
Plug 'aklt/plantuml-syntax'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" color schemes
"""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'NLKNguyen/papercolor-theme'


call plug#end()

set spell spelllang=en_us
syntax enable
set title                           "set xterm title to vim title
set titleold=""
set tabstop=4                       "a tab is four spaces.
set shiftwidth=4                    "four spaces for autoindenting
set softtabstop=4
set expandtab                       "Insert spaces instead of tabs
set shiftround                      "use multiple of shiftwidth for indenting
set encoding=utf-8
set smartindent                     "Seems to do a decent job with indenting
set scrolloff=2                     "always show lines of code above/below cursor
set hidden                          "Dont delete buffers, just hide them. Lets us :e another file without having to s
set wildmenu                        "improve auto complete menu
set wildmode=list:longest           "when tab is pressed, show a list similar to ls
set cursorline                      "highlight the line the cursor is on
set ttyfast                         "it is fast, this aint no modem
set ruler
set backspace=indent,eol,start      "Backspace over everything
set laststatus=2                    "always show status bar
set number
set showmatch                       "highligh matching [{()}]
set undofile                        "save undo tree when file is closed
set undodir=~/.vim/undo             "undo files should be kept out of the working dir
set undolevels=1000                 "Many many levels of undo
set backup                          "backup files should be kept out of the working dir
set backupdir=~/.vim/backup
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

"Customize python settings
autocmd bufreadpre *.py setlocal textwidth=79
autocmd bufreadpre *.py setlocal colorcolumn=80

"show unwanted whitespace
set list
set list listchars=tab:»·,trail:·,extends:…
set showbreak=\ \ …\ 
set background=dark
set history=1000                    "Remember a ton of commands
set mouse=a                         "Allow for better mouse interaction

colorscheme PaperColor
highlight Cursor guifg=yellow guibg=red


" make portmaps and other things indent using shiftwidth value and not location of ( + shiftwidth
let g:vhdl_indent_genportmap = 0

" change leader to space, nicer to type. You loose some sort of 'move to next char' command. 
let mapleader = "\<Space>"
"leader-c will close all the extra windows created by ack/syntastic, etc
nmap <silent> <leader>c :lclose <bar> cclose <cr>
nmap <silent> <leader>t :TagbarToggle<CR>
nmap <silent> <leader>g :GundoToggle<CR>
nmap <silent> <Leader>a :FSHere<cr>
nmap <leader>s :Ack!<cr>
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

" fix direction keys for line wrap, other wise they jump over wrapped lines
nnoremap j gj
nnoremap k gk

"remap f1. I'll type :help when I want it
map <F1> <ESC>
imap <F1> <ESC>

"keep cursor in the middle of the screen while keyscrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" I have never intentionally entered the mode that q: gives.
map q: :q
nnoremap Q <nop>

" make it a little harder to start recording a macro. I accidently record more than not
noremap <Leader>q q
noremap q <nop>

" :wq when I meant :w. Nudges towards using :x
cmap wq w

" change tabstops for lua to be 2
au FileType lua setl sw=2 sts=2 et
