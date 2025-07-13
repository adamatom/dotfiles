# Automatically sourced by zsh on interactive shells
# .zshenv → [.zprofile if login] → [.zshrc if interactive] → [.zlogin if login] → [.zlogout sometimes]
# Enable profiling
__PROFILE__=0
if [[ $__PROFILE__ -eq 1 ]]; then
    zmodload zsh/zprof  # launch shell then run 'zprof'
fi

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

stty -ixon

. "$HOME/.cargo/env"

if [ -f "$HOME/.local/share/../bin/env" ]; then
    . "$HOME/.local/share/../bin/env"
fi
