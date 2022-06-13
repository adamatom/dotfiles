# Change highlight to use a blue background
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=blue,fg=white,bold'

# Use async suggestion engine that uses zsh/zpty module
ZSH_AUTOSUGGEST_USE_ASYNC="1"

# Bind F10 to execute the autosuggestion. I map Shift-Return to F10 in terminal
# emulator.
bindkey '^[[21~' 'autosuggest-execute'

_zsh_autosuggest_strategy_histdb_top() {
    local query="
        select commands.argv from history
        left join commands on history.command_id = commands.rowid
        left join places on history.place_id = places.rowid
        where commands.argv LIKE '$(sql_escape $1)%'
        group by commands.argv, places.dir
        order by places.dir != '$(sql_escape $PWD)', count(*) desc
        limit 1
    "
    suggestion=$(_histdb_query "$query")
}

ZSH_AUTOSUGGEST_STRATEGY=histdb_top
