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

source ~/.zsh/plugins.zsh
source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.p10k.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/history.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/completion.zsh
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
