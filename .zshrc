# Automatically sourced by zsh on interactive shells
# .zshenv → [.zprofile if login] → [.zshrc if interactive] → [.zlogin if login] → [.zlogout sometimes]
# Enable profiling
#zmodload zsh/zprof  # launch shell then run 'zprof'

source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/history.zsh
source ~/.zsh/z.sh
source ~/.zsh/plugins.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/completion.zsh
if [ -f ~/.zsh_local.zsh ]; then
    source ~/.zsh_local.zsh
fi
if which tmux &> /dev/null; then
    if [ -z $TMUX ] && [[ "$DISPLAY" != "" ]]; then tmux; fi
fi

stty -ixon
