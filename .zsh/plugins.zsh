function update_plugins() {
    print -P '%B%F{cyan}Updating plugins%b%f'
    zplug update
    touch ~/.cache/zplug/timestamp
}

function zvm_config() {
    # Allow yanking to clipboard from zsh-vim-mode plugin
    ZVM_SYSTEM_CLIPBOARD_ENABLED=true
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
        exec_type=$'zle accept-line'
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
    zvm_cmd_key 1 vicmd ' gf'  git fetch
    zvm_cmd_key 1 vicmd ' ga'  git add -up
    zvm_cmd_key 1 vicmd ' gc'  git commit
    zvm_cmd_key 1 vicmd ' gr' git rebase -i origin/main
    zvm_cmd_key 0 vicmd ' gp' git push --force origin
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

export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l ""'
