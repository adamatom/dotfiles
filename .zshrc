# Automatically sourced by zsh on interactive shells
# .zshenv → [.zprofile if login] → [.zshrc if interactive] → [.zlogin if login] → [.zlogout sometimes]
# Enable profiling
__PROFILE__=0
if [[ $__PROFILE__ -eq 1 ]]; then
    zmodload zsh/zprof  # launch shell then run 'zprof'
fi

source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/history.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/plugins.zsh
source ~/.zsh/plugin_options.zsh
source ~/.zsh/bindkeys.zsh
if [ -f ~/.zsh_local.zsh ]; then
    source ~/.zsh_local.zsh
fi

stty -ixon
