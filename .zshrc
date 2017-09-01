# Enable profiling
#zmodload zsh/zprof  # launch shell then run 'zprof'

source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/history.zsh
source ~/.zsh/z.sh
source ~/.zsh/plugins.zsh
source ~/.zsh/bindkeys.zsh
if [ -f ~/.zsh_local.zsh ]; then
    source ~/.zsh_local.zsh
fi

