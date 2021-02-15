set encoding=utf-8            "Enable utf-8 support
scriptencoding utf-8
filetype plugin indent on     " required!

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

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
  set guioptions+=c  "dont use gui modal dialogs
  "set guifont=Fira\ Code\ 14
  set guifont=Noto\ Mono\ 12
elseif has('termguicolors')           " Use fg/bg colors from terminal (compatible terminals only)
  set termguicolors
  "  set t_ut=""        "Dont rely on Background Color Erase (BCE) support from terminal emulator
endif

function! s:CreateDir(name)
  " Create a given directory if it does not exist.
  if !isdirectory(a:name)
    echo 'creating '.a:name
    call mkdir(a:name, 'p')
  endif
endfunction

" Tame backup/undo/swap/info file management
set undodir=$HOME/.vim/undo         " centralize files working directory
call s:CreateDir(expand(&undodir))  " create the directory if needed

set backupdir=/tmp//                " backup files should be kept out of the working dir
set directory=/tmp//                " store swap files in a centralized place, not in working dir


set hidden                      " dont delete buffers, just hide them
set undofile                    " save undo tree when file is closed
set undolevels=1000             " many levels of undo
set backup                      " record backup files for crashes
set history=1000                " Remember a ton of commands
set viminfo+=n~/.vim/viminofo

" Tame searching
set smartcase                   " ignore case in a search until there is some capitalization
set ignorecase                  " smartcase cant do its job unless this is set
set gdefault                    " assume 'g' on s///g
set incsearch                   " Jump to the first instance as you type the search term
set showmatch                   " always show matching ()'s
set hlsearch                    " highlight all of the search terms

" Whitespace and indentation
set tabstop=4                   " a tab is four spaces.
set shiftwidth=4                " four spaces for auto-indenting
set softtabstop=4
set expandtab                   " insert spaces instead of tabs
set smartindent                 " follow c-like indentation guidelines
set list                        " show whitespace as defined by listchars
set listchars=tab:»·,trail:·,extends:…
set showbreak=\ \ …\ 
set autoindent                  " copy indent from current line when starting a new line
set shiftround                  " round to shiftwidth instead of inserting tabstop characters

" Line wrapping, cursors, cursor lines
set nowrap                      " dont display long-lines as wrapped
set textwidth=99                " automatically try to break long lines as they are typed
set scrolloff=2                 " always show lines of code above/below cursor
set sidescroll=5                " always show extra context characters horizontally
set colorcolumn=100            " show a column indicating max line length

" Tame auto formatting, see :h fo-table
set formatoptions=
set formatoptions+=c            " auto-wrap comments using textwidth
set formatoptions+=r            " insert current comment leader when hitting <enter>
set formatoptions+=q            " allow reformatting of comments with gq
set formatoptions+=n            " when formatting text, recognize numbered lists
set formatoptions+=1            " break long lines before single char words instead of after

" User interface
set spell                       " enable spelling by default
set spelllang=en_us             " when spelling is enabled, use US English dictionary
set title                       "set xterm title to vim title
set titleold=""
set wildmenu                    " improve auto complete menu
set wildmode=longest:full,full  " when tab is pressed, show a list similar to ls
set wildignore+=*.pyc,*.o,*.zwc " hide certain files form wildmenu
set nofoldenable                "I dont like folding text, so disable it everywhere
set diffopt=filler,context:1000000 " filler is default and inserts empty lines for sync
set backspace=indent,eol,start  " Backspace over everything
set laststatus=2                " always show status bar
set noshowmode                  " dont display addition '-- INSERT --' below airline
set number                      " display line numbers
set ruler                       " display cursor location, only applies when no airline plugin
set mouse=a                     " mouse can be used to move and select windows, select text
set ttymouse=sgr                " use sgr mode for mouse for xterm controls + more columns
set ttimeoutlen=10              " decrease timeout for terminal keycodes for faster insert exits
set ttyfast                     " it is fast, this aint no modem
set clipboard=unnamedplus       " use the clipboard as the unnamed register
set cmdheight=1                 " better display of messages
set updatetime=1000             " one second
set belloff=all                 " disable the bell for everything
set completeopt=menuone,noinsert
set showcmd                     " display an active vim sequence if there is one
set notimeout                   " a vim command in-progress will not expire, <esc> to exit
set splitbelow                  " open new hsplits to the bottom
set splitright                  " open new vsplits to the right
"-------
"Keymaps
"-------
"
" change leader to space, nicer to type. You lose some sort of 'move to next char' command.
let g:mapleader = "\<Space>"

" leader maps for running common actions


" toggle spelling quickly
nnoremap <silent> <leader>os :set spell! spell?<CR>

" toggle line numbers
nnoremap <silent> <leader>on :set number! number?<CR>

" toggle relative number
nnoremap <silent> <leader>or :set relativenumber! relativenumber?<CR>

" navigate through quickfix and locationlists
nnoremap <silent> <leader>q :cnext<CR>
nnoremap <silent> <leader>Q :cprevious<CR>

nnoremap <silent> <leader>l :lnext<CR>
nnoremap <silent> <leader>L :lprevious<CR>

nnoremap <silent> <leader><leader>w :w<CR>

" use leader {y|d|p} for interacting with the system clipboard
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

" Switch between the last two files
nnoremap <Leader>a <C-^>

" run make silently and open the quickfix window in case of errors
nnoremap <leader>m :silent make\|redraw!\|cc<CR>

" Spell check the last error.
" <ctrl-g>u     create undo marker (before fix) so we can undo/redo this
"               change. Otherwise vim treats the spelling correction as the
"               same change as our edit.
" esc           enter normal mode
" [s            jump back to previous spelling mistake
" 1z=           take the first correction
" `]            jump back
" a             continue editing
" <ctrl-g>u     create another undo marker
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" run :Ack! <word-under-cursor>
nnoremap <leader>F :Ack! <c-r><C-w><cr>

" Begin a word search and replace
nnoremap <leader>R :%s/\<<C-r><C-w>\>//c<Left><Left>

" Keymaps that alter default behavior
" -----------------------------------

" Advance to next misspelling after adding a word to the spellfile.
noremap zg zg]s

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
noremap <F1> <ESC>
inoremap <F1> <ESC>

" I have never intentionally entered the mode that q: gives.
noremap q: :q

nnoremap Q <nop>

"Make up/down/cr map to the (oddly) more useful ctrl-n, ctrl-p, ctrl-y, ctrl-e
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"

"Use ctrl-j/k for popup menu
inoremap <expr> <C-j>     pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k>       pumvisible() ? "\<C-p>" : "\<C-k>"

" Indent in visual and select mode automatically re-selects.
vnoremap > >gv
vnoremap < <gv

" command mode replacements
" -------------------------

" :wq when I meant :w. Nudges towards using :x
cabbrev wq w

" :W isnt a command, and I usually intend on :w
cabbrev W w

" :X is a strange crypto thing that I dont care about, intention is :x
cabbrev X x

" :Q enters modal ex mode, I'm happy with just ex command line. Generally mistyped :q
cabbrev Q q

" Similar to above, I generally mean :qa
cabbrev Qa qa

" Tabnew -> tabnew
cabbrev Tabnew tabnew

" Allow saving of files as sudo when I forgot to start vim using sudo.
cabbrev w!! w !sudo tee > /dev/null % <bar> edit!

" Close all but the current buffer (or any that arent yet saved)
command! BufOnly silent! execute "%bd|e#|bd#"

augroup allfiles
  "Wipe out the allfiles group for when we reload the vimrc. Otherwise we just keep reattaching commands
  autocmd!

  "Use markdown filetype for unknown files.
  autocmd BufEnter * if &filetype == "" | setlocal ft=markdown | endif

  "autowrap text when working in markdown files
  autocmd FileType markdown setlocal formatoptions+=t

  "consider '-' as part of the same word
  autocmd FileType markdown setlocal iskeyword+=-

  "Spell checking when working with markdown
  autocmd FileType markdown setlocal spell

  "Spell checking during gitcommit.
  autocmd FileType gitcommit setlocal spell

  "Customize python settings
  autocmd filetype python setlocal textwidth=99 colorcolumn=100 sw=4 sts=4 et

  "Customize vimL settings
  autocmd filetype vim setlocal textwidth=99 colorcolumn=100 sw=2 sts=2 et

  "Change lua tabstops to be more lua-esque
  autocmd FileType lua setlocal sw=2 sts=2 et

  "Close the preview window if it is open
  autocmd InsertLeave * pclose
augroup END

if filereadable(expand($HOME.'/.vimrc.plugins'))
  source $HOME/.vimrc.plugins
  set background=dark
  let g:one_allow_italics = 1
  let g:onedark_terminal_italics = 1
  let g:onedark_termcolors = 256
  let g:palenight_terminal_italics=1
  let g:gruvbox_italic = 1
  let g:gruvbox_contrast_dark='hard'
  let ayucolor='mirage'
  " colorscheme ayu
  " colorscheme tender
  " colorscheme PaperColor
  " colorscheme snazzy
  " colorscheme dracula
  " colorscheme space_vim_theme
  " colorscheme termschool
  " colorscheme OceanicNext
  " colorscheme materialbox
  " colorscheme carbonized-dark
  " colorscheme one
  " colorscheme onedark
  " colorscheme neodark
  " colorscheme palenight
  " colorscheme base16-phd
  " colorscheme base16-solarized-light
  " colorscheme base16-porple
  " colorscheme base16-snazzy
  " colorscheme corvine
  " colorscheme vim-framer-syntax
  if has('gui_running')
    colorscheme onedark
  else
    colorscheme purify
  endif
endif
