TIMESTAMP_FILE=~/.cach/zplug
function update_plugins() {
    print -P '%B%F{cyan}Updating plugins%b%f'
    zplug update
    touch ~/.cache/zplug/timestamp
}

function load_plugins() {

    zplug "zsh-users/zsh-syntax-highlighting"
    zplug "zsh-users/zsh-history-substring-search"
    zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-completions"
    zplug "adamatom/zsh-cwd-history"

    # enhancd introduces an issue with revision 0d39876
    # see https://github.com/b4b4r07/enhancd/issues/101
    zplug "b4b4r07/enhancd", use:init.sh, at:718bd319cce2d985a90211f3b6c00851995f039e
    if zplug check "b4b4r07/enhancd"; then
        export ENHANCD_FILTER="fzf --height 50% --reverse --ansi --preview 'ls -l {}' --preview-window down"
        export ENHANCD_DOT_SHOW_FULLPATH=1
    fi

    # Grab binaries from GitHub Releases
    # and rename with the "rename-to:" tag
    zplug "junegunn/fzf-bin", \
        from:gh-r, \
        as:command, \
        rename-to:fzf, \
        use:"*linux*amd64*"

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi

    zplug load

    # history-substring-search options
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=white,bold'
    # zsh-autosuggestions options
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=239'

    # zsh-syntax-highlighting
    # Turn a lot of the highlighting off
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
