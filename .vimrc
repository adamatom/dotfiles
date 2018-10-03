set encoding=utf-8            "Enable utf-8 support
scriptencoding utf-8
filetype plugin indent on     " required!
syntax enable

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
set backupdir=$HOME/.vim/backup     " backup files should be kept out of the working dir
call s:CreateDir(expand(&backupdir))
set directory=$HOME/.vim/tmp        " store swap files in a centralized place, not in working dir
call s:CreateDir(expand(&directory))

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
set shiftwidth=4                " four spaces for autoindenting
set softtabstop=4
set expandtab                   " insert spaces instead of tabs
set smartindent                 " follow c-like indentation guidelines
set list                        " show whitespace as defined by listchars
set list listchars=tab:»·,trail:·,extends:…
set showbreak=\ \ …\ 
set autoindent                  " copy indent from current line when starting a new line
set shiftround                  " round to shiftwidth instead of inserting tabstop characters
set iskeyword+=-                " treat dashes as part of word motion

" Line wrapping, cursors, cursor lines
set nowrap                      " dont display long-lines as wrapped
set textwidth=79                " automatically try to break long lines as they are typed
set scrolloff=2                 " always show lines of code above/below cursor
set sidescroll=5                " always show extra context chracters horizontally
set cursorline                  " highlight the line the cursor is on
set cursorcolumn                " highlight the column the cursor is on
set colorcolumn=80            " show a column indicating max line length


" Tame auto formating, see :h fo-table
set formatoptions=
set formatoptions+=c            " auto-wrap comments using textwidth
set formatoptions+=r            " insert current comment leader when hitting <enter>
set formatoptions+=q            " allow reformating of comments with gq
set formatoptions+=n            " when formatting text, recognize numbered lists
set formatoptions+=1            " break long lines before single char words instead of after

" User interface
set nospell                     " disable spelling by default
set spelllang=en_us             " when spelling is enabled, use US english dictionary
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

if filereadable(expand($HOME.'/.vimrc.keymaps'))
    source $HOME/.vimrc.keymaps
endif

if filereadable(expand($HOME.'/.vimrc.autocmd'))
    source $HOME/.vimrc.autocmd
endif

if filereadable(expand($HOME.'/.vimrc.plugins'))
    source $HOME/.vimrc.plugins
    if (has('termguicolors'))           " Use fg/bg colors from terminal (compatible terminals only)
        set termguicolors
    endif
    set background=dark
    let g:onedark_terminal_italics = 1
    colorscheme onedark
    let g:lightline['colorscheme'] = 'onedark'
endif
