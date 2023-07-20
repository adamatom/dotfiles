function update_plugins() {
    print -P '%B%F{cyan}Updating plugins%b%f'
    zplug update
    touch ~/.cache/zplug/timestamp
}

function load_plugins() {
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
            eval "$(zoxide init zsh)"
        fi
    else
        eval "$(zoxide init zsh)"
    fi

    if ! builtin which mcfly > /dev/null; then
        printf "mcfly not detected, download and install to ~/.local/bin? [y/N]: "
        if read -q; then
            echo; wget -P /tmp https://github.com/cantino/mcfly/releases/download/v0.8.1/mcfly-v0.8.1-x86_64-unknown-linux-musl.tar.gz
            tar -zxf /tmp/mcfly-v0.8.1-x86_64-unknown-linux-musl.tar.gz -C ~/.local/bin
            eval "$(mcfly init zsh)"
        fi
    else 
        eval "$(mcfly init zsh)"
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

export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l ""'
