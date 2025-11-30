# Automatically sourced by zsh on interactive shells
# .zshenv → [.zprofile if login] → [.zshrc if interactive] → [.zlogin if login] → [.zlogout sometimes]
# Enable profiling
__PROFILE__=0
if [[ $__PROFILE__ -eq 1 ]]; then
    zmodload zsh/zprof  # launch shell then run 'zprof'
fi

# Caching hacks to speed things up
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Enable Powerlevel10k instant prompt. Should be the very first line in ~/.zshrc.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
[[ -r ~/.cache/p10k-instant-prompt-${(%):-%n}.zsh ]] && source ~/.cache/p10k-instant-prompt-${(%):-%n}.zsh

# Plugins -----------------------------------------------------------------------------------------
function update_plugins() {
    print -P '%B%F{cyan}Updating plugins%b%f'
    zplug update
    touch ~/.cache/zplug/timestamp
}

function zvm_config() {
    # Allow yanking to clipboard from zsh-vim-mode plugin
    ZVM_SYSTEM_CLIPBOARD_ENABLED=true
    # Only changing the escape key to `jj` in insert mode, we still
    # keep using the default keybindings `^[` in other modes
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
}

function zvm_cmd_key() {
    # Helper: bind a key in a zvm keymap to "run this command"
    local do_exec=$1; shift     # execute command immediately if 1
    local mode=$1; shift        # e.g. vicmd / viins / visual
    local keys=$1; shift        # e.g. ' gf'
    local cmd="$*"              # rest of the args as a single string

    # Create a unique, safe widget name from mode+keys
    local widget="zvm_cmd_${mode}_${${keys//[^A-Za-z0-9]/_}}"

    local exec_type
    if [[ $do_exec -eq 1 ]]; then
        exec_type=$'zle .accept-line'
    else
        exec_type=$'CURSOR=${#BUFFER}'
    fi

    eval "
        function $widget() {
            zle -I
            BUFFER=${(q)cmd}
            $exec_type
        }
    "

    zvm_define_widget "$widget"
    zvm_bindkey "$mode" "$keys" "$widget"
}

function zvm_after_lazy_keybindings() {
    # The plugin will auto execute this zvm_after_lazy_keybindings function
    zvm_cmd_key 1 vicmd ' ga' git add -up
    zvm_cmd_key 1 vicmd ' gc' git commit
    zvm_cmd_key 1 vicmd ' gf' git fetch
    zvm_cmd_key 1 vicmd ' gg' git closegone
    zvm_cmd_key 0 vicmd ' gp' git push --force origin
    zvm_cmd_key 1 vicmd ' gr' git rebase -i origin/main
}

function zvm_after_init() {
    # zvm necessarily clobbers keybinds, and we want to reclaim them, so we do sourcing of extra
    # utilities after we initialize zvm. This would be moved back into load_plugins() if zvm is
    # removed.
    if builtin which zoxide > /dev/null; then
        eval "$(zoxide init zsh)"
    fi

    if builtin which mcfly > /dev/null; then
        eval "$(mcfly init zsh)"
    fi

    if builtin which direnv > /dev/null; then
        eval "$(direnv hook zsh)"
    fi
}

function load_plugins() {
    zplug "jeffreytse/zsh-vi-mode"  # Sane vi-mode
    zplug "romkatv/powerlevel10k", as:theme, depth:1  # fancy prompt
    zplug "zsh-users/zsh-syntax-highlighting"  # syntax highlighting with the shell
    zplug "zsh-users/zsh-completions"

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi

    zplug load

    if ! builtin which zoxide > /dev/null; then
        printf "zoxide not detected, sudo apt install zoxide? [y/N]: "
        if read -q; then
            echo; sudo apt install zoxide
        fi
    fi

    if ! builtin which mcfly > /dev/null; then
        printf "mcfly not detected, download and install to ~/.local/bin? [y/N]: "
        if read -q; then
            echo; wget -P /tmp https://github.com/cantino/mcfly/releases/download/v0.9.2/mcfly-v0.9.2-x86_64-unknown-linux-musl.tar.gz
            tar -zxf /tmp/mcfly-v0.9.2-x86_64-unknown-linux-musl.tar.gz -C ~/.local/bin
        fi
    fi

    if ! builtin which direnv > /dev/null; then
        printf "direnv not detected, download and install to ~/.local/bin? [y/N]: "
        if read -q; then
            echo; wget -P /tmp https://github.com/direnv/direnv/releases/download/v2.37.0/direnv.linux-amd64
            cp /tmp/direnv.linux-amd64 ~/.local/bin/direnv && chmod +x ~/.local/bin/direnv
        fi
    fi

    # history-substring-search options
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=white,bold'
    # zsh-autosuggestions options
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=239'

    # zsh-syntax-highlighting
    # Turn a lot of the highlighting off
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[builtin]=none
    ZSH_HIGHLIGHT_STYLES[function]=none
    ZSH_HIGHLIGHT_STYLES[alias]=none
    ZSH_HIGHLIGHT_STYLES[command]=none
    ZSH_HIGHLIGHT_STYLES[precommand]=none
    ZSH_HIGHLIGHT_STYLES[commandseparator]=none
    ZSH_HIGHLIGHT_STYLES[hashed-command]=none
    ZSH_HIGHLIGHT_STYLES[path]=none
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=cyan
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=cyan
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[comment]=fg=gray

    # Change highlight to use a blue background
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=blue,fg=white,bold'
}

function update_and_load() {
    source ~/.zplug/init.zsh

    if [[ "$(command -v zplug)" == "" ]]; then
        print -P '%B%F{red}zplug not installed, aborting plugin initialization%b%f'
        return 1
    fi

    if [[ ! -d ~/.cache/zplug ]]; then
        mkdir -p ~/.cache/zplug
    fi

    if [[ ! -f ~/.cache/zplug/timestamp ]]; then
        touch -t 200001010101 ~/.cache/zplug/timestamp
    fi

    if [ $(find "$HOME/.cache/zplug/timestamp" -mmin +10080) ]; then
        update_plugins
    fi

    load_plugins
}

update_and_load

source ~/.p10k.zsh

# setopts -----------------------------------------------------------------------------------------
# ===== Basics
autoload colors; colors
setopt no_beep  # dont beep on error
unsetopt flow_control # disable ^q/^s
setopt interactive_comments # Allow comments even in interactive shells

# ===== Changing Directories
setopt auto_cd # If you type foo, and it isnt a command, and it is a directory in your cdpath, go there
setopt cdablevarS # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups # dont push multiple copies of the same directory onto the directory stack

setopt autopushd  # make cd act like pushd automatically
setopt pushdminus  # swap the +/- meaning in cd -1, it matches the output of dirs better
setopt pushdsilent  # dont print dir when we pushd
setopt pushdtohome  # put home dir on stack when we type 'cd', since cd now does a pushd

# ===== Expansion and Globbing
setopt extended_glob # treat #, ~, and ^ as part of patterns for filename generation

# ===== History
setopt append_history # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history # save timestamp of command and duration
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_fcntl_lock # Dont use zsh adhoc locking mechanism, use OS's fcntl for HISTFILE lock
setopt hist_find_no_dups # When searching history dont display results already cycled through twice
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
setopt hist_verify # dont execute, just expand history
setopt share_history # imports new commands and appends typed commands to history

# ===== Completion 
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word    
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word # Allow completion from within a word/phrase

unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
setopt correct # spelling correction for commands
setopt correctall # spelling correction for arguments

# ===== Prompt
setopt prompt_subst # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt transient_rprompt # only show the rprompt on the current prompt
setopt IGNORE_EOF # disable ctrl-d to logout

# ===== Scripts and Functions
setopt multios # perform implicit tees or cats when multiple redirections are attempted

# aliases -----------------------------------------------------------------------------------------
export LANG="en_US.UTF-8"

export GOPATH=$HOME/.go
export RUBYGEMPATH=$HOME/.gem/ruby/2.5.0/

export PATH=$PATH:$HOME/.rye/shims:$HOME/.bin:$GOPATH/bin:$RUBYGEMPATH/bin:$HOME/.local/bin:$HOME/projects/tek-linux/node_modules/.bin/
# disable paging for git delta.
export DELTA_PAGER=""
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export LESS='--quit-if-one-screen --ignore-case --status-column --chop-long-lines --long-prompt --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --window=-4'
export MANPAGER='less +Gg'
export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l ""'
export MCFLY_RESULTS=100
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_RESULTS_SORT=LAST_RUN

alias ssh="TERM=xterm-256color ssh"
alias ls="ls -lA --color=always --group-directories-first"
alias lsd="ls -lAtr --color=always --group-directories-first"
alias xclip="xclip -selection clipboard"
alias gvim="gvim $* 2>/dev/null"
alias pyclean="find . | grep -E \"(\.mypy_cache|\.pytest_cache|__pycache__|\.pyc|\.pyo$)\" | sudo xargs rm -rf"
alias spotify="spotify --force-device-scale-factor=2.0"
alias vi="vim"
alias pvim="PYTHONPATH=$(pwd) vim"
alias pgvim="PYTHONPATH=$(pwd) gvim"
alias p="python"
alias grep="grep --color=auto"
alias zshcolors='for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done'
alias sudo="nocorrect sudo"
alias dirh="dirs -v"
alias cdh="dirs -v"
alias reflectarch="sudo /usr/bin/reflector --protocol https --latest 30 --number 20 --sort rate --save /etc/pacman.d/mirrorlist"
alias did="vim +'normal Go' +'r!date' ~/did.txt"
alias gitlines="git ls-files | while read f; do git blame -w -M -C -C --line-porcelain "$f" | grep -I '^author '; done | sort -f | uniq -ic | sort -nr"
alias open="xdg-open"
alias ssh-weechat="echo -e '\033]2;'weechat'\007'; ssh adam@adamatom.com -t screen -D -RR weechat weechat"
alias pipenv="nocorrect pipenv"
alias tmux="env TERM=tmux-256color tmux"
alias backupb2="rclone sync /home/adam b2:Pascal-Backup --transfers 32 --filter-from /home/adam/rclone-files.txt --fast-list -P -L --b2-hard-delete"
alias pip="pip3"
alias vc="nvim ~/.vimrc"
alias vp="nvim ~/.vimrc.plugins"
alias gitk="gitk &"

launch() {
    "$@" 2>/dev/null & disown
}

config() {
    if [[ $@ =~ "^clean" ]]; then
        echo "LOLLLLLLL, you almost blew up your home directory"
    else
        git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
    fi
}

zshrecompile() {
    autoload -U zrecompile
    rm -f ~/.zsh/*.zwc
    [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
    [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old

    for f in ~/.zsh/**/*.zsh; do
        [[ -f $f ]] && zrecompile -p $f
        [[ -f $f.zwc.old ]] && rm -f $f.zwc.old
    done

    [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
    [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old

    source ~/.zshrc
}

# History -----------------------------------------------------------------------------------------
HISTSIZE=10000
SAVEHIST=9000
HISTFILE=~/.zsh_history

# Completion --------------------------------------------------------------------------------------
autoload -Uz compinit
compinit
zmodload -i zsh/complist

# Speedup path completion
zstyle ':completion:*' accept-exact '*(N)'

# Fallback to built in ls colors
zstyle ':completion:*' list-colors ''

# Make the list prompt friendly
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

# Make the selection prompt friendly when there are a lot of choices
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Add simple colors to kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Change to a more verbose process listing so kill<TAB> shows everything for user
zstyle ':completion:*:processes' command 'ps ux'

zstyle ':completion:*' menu select=1

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
 
# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:scp:*' tag-order files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show

# Dont fall back from the new completion system to the old `compctl` automatically.
zstyle ':completion:*' use-compctl false

# -------------------------------------------------------------------------------------------------
if [ -f ~/.zsh_local.zsh ]; then
    source ~/.zsh_local.zsh
fi

if [ -f $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
    source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

. "$HOME/.cargo/env"

if [ -f "$HOME/.local/share/../bin/env" ]; then
    . "$HOME/.local/share/../bin/env"
fi

# Disable Ctrl-s/Ctrl-q, which freezes and unfreezes the terminal.
if [[ -t 0 ]]; then
  stty -ixon 2>/dev/null || true
fi
