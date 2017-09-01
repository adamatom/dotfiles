#setopt promptsubst
autoload -U colors && colors # Enable colors in prompt

# add the add-zsh-hook command
autoload add-zsh-hook

# Stolen from oh-my-zsh
ZSH_THEME_GIT_PROMPT_PREFIX="%B%F{255} › %b%F{green}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"

ZSH_THEME_GIT_PROMPT_MERGING="%B%F{magenta} ⚡︎%f%b"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%B%F{yellow} ◒%f%b"
ZSH_THEME_GIT_PROMPT_ADDED="%B%F{green} ✚%f%b"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{yellow} ✹%f"
ZSH_THEME_GIT_PROMPT_DELETED="%B%F{red} ✖%f%b"
ZSH_THEME_GIT_PROMPT_UNMERGED="%B%F{blue} §%f%b"
ZSH_THEME_GIT_PROMPT_AHEAD="%B%F{cyan} ⇡NUM%f%b"
ZSH_THEME_GIT_PROMPT_BEHIND="%B%F{cyan} ⇣NUM%f%b"

# Get the status of the working tree
function git_prompt_string() {
  local INDEX=$(command git status --porcelain -b 2> /dev/null)
  STATUS=""
  repo_info=$(git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree --short HEAD 2>/dev/null)
  if [ -z $repo_info ]; then 
    return
  fi
  $(git diff --no-ext-diff --quiet --exit-code 2> /dev/null) ||  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_MODIFIED"
  $(git diff-index --cached --quiet HEAD -- 2> /dev/null) ||  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_ADDED"
  if $(git ls-files --others --exclude-standard --error-unmatch -- ':/*' >/dev/null 2>/dev/null); then
   STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    STATUS="$ZSH_THEME_GIT_PROMPT_STASHED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
      STATUS=$STATUS${ZSH_THEME_GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
      STATUS=$STATUS${ZSH_THEME_GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
      STATUS=$STATUS$ZSH_THEME_GIT_PROMPT_MERGING
  fi
  local git_where="$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD 2> /dev/null)"
  git_where=${git_where/refs\/heads\//}
  git_where=${git_where/tags\//}
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${git_where}$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}


ASYNC_PROC=0
function precmd() {

    function async() {
        local hoststyle=''
        $(config diff --no-ext-diff --quiet --exit-code 2> /dev/null) && hoststyle='%F{239}' || hoststyle='%F{009}'

        local gitinfo=''
        local pend=$'%F{255}]%f\n'$PROMPT_CHAR
        local pstart="%F{255}[${hoststyle}%M%F{255} › %F{074}%~%f"
        # If in a git repo, asynchronously fill in the git details into PROMPT
        if git rev-parse --git-dir > /dev/null 2>&1; then
            gitinfo="$(git_prompt_string)"
        fi

        # save to temp file
        printf "%s" $pstart$gitinfo$pend > "/tmp/zsh_prompt_$$"

        # Update the title while we are at it
        print -Pn "\e]0;%~\a"

        # signal parent
        kill -s USR1 $$
    }

    # kill child if necessary
    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi

    # start background computation
    async &!
    ASYNC_PROC=$!

}

function TRAPUSR1() {
    # read from temp file
    PROMPT="$(cat /tmp/zsh_prompt_$$)"
    # reset proc number
    ASYNC_PROC=0

    # redisplay
    zle && zle reset-prompt
}

PROMPT_CHAR='%(?.%F{white}.%F{red})%(1j.%Uλ%u.λ)%f %F{255}%B›%b%f '

PROMPT=$'%F{255}[%F{239}%M%F{255} › %F{074}%~%f%F{255}]%f\n'$PROMPT_CHAR
RPROMPT='' # no initial prompt, set dynamically

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "
