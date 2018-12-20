# Change highlight to use a blue background
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=blue,fg=white,bold'

# Use async suggestion engine that uses zsh/zpty module
ZSH_AUTOSUGGEST_USE_ASYNC="1"

# Bind F10 to execute the autosuggestion. I map Shift-Return to F10 in terminal
# emulator.
bindkey '^[[21~' 'autosuggest-execute'
