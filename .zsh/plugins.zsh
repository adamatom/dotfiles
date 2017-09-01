function periodically_update_plugins() {
    if [ ! -f ~/.cache/antibody/timestamp ]; then
        touch -t 200001010101 ~/.cache/antibody/timestamp
    fi

    if test $(find "$HOME/.cache/antibody/timestamp" -mmin +10080); then
        print -P '%B%F{cyan}Updating plugins%b%f'
        antibody bundle < ~/.zsh/antibody_plugins.txt  > ~/.zsh/antibody_sourceables.zsh
        antibody update
        touch ~/.cache/antibody/timestamp
    fi
}

function load_plugins() {
    periodically_update_plugins
    source ~/.zsh/antibody_sourceables.zsh

    # history-substring-search options
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=white,bold'
    # zsh-autosuggestions options
    ZSH_AUTOSUGGEST_STRATEGY=directory_history
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=239'

    # zsh-syntax-highlighting
    # Turn a lot of the highlighting off
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=blue
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

if [[ -f ~/.zsh/antibody_plugins.txt && -f ~/.zsh/antibody_sourceables.zsh ]]; then
    load_plugins
elif [[ -f ~/.zsh/antibody_plugins.txt ]]; then
    print -P '%B%F{cyan}Initializing antibody_sourceables%b%f'
    touch -t 200001010101 ~/.cache/antibody/timestamp
    antibody bundle < ~/.zsh/antibody_plugins.txt  > ~/.zsh/antibody_sourceables.zsh
    load_plugins
else
    print -P '%B%F{red}Plugins not loaded, $HOME/.zsh/antibody_plugins.txt not detected%b%f'
fi
