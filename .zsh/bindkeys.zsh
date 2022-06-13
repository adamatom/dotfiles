bindkey -e   # Default to standard emacs bindings, regardless of editor string
# With the history-substring-search plugin and these binds you get a Fish-like search
# bindkey '^[OA' history-substring-search-up
# bindkey '^[OB' history-substring-search-down
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey "^[[3~" delete-char
