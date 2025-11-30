export LANG="en_US.UTF-8"

export GOPATH=$HOME/.go
export RUBYGEMPATH=$HOME/.gem/ruby/2.5.0/

export PATH=$PATH:$HOME/.rye/shims:$HOME/.bin:$GOPATH/bin:$RUBYGEMPATH/bin:$HOME/.local/bin:$HOME/projects/tek-linux/node_modules/.bin/
# disable paging for git delta.
export DELTA_PAGER=""
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export LESS='--quit-if-one-screen --ignore-case --status-column --chop-long-lines --long-prompt --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --window=-4'
export MANPAGER='less +Gg'
export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l ""'
export MCFLY_RESULTS=100
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_RESULTS_SORT=LAST_RUN

alias ssh="TERM=xterm-256color ssh"
alias ls="ls -lA --color=always --group-directories-first"
alias lsd="ls -lAtr --color=always --group-directories-first"
alias xclip="xclip -selection clipboard"
alias gvim="gvim $* 2>/dev/null"
alias pyclean="find . | grep -E \"(\.mypy_cache|\.pytest_cache|__pycache__|\.pyc|\.pyo$)\" | sudo xargs rm -rf"
alias spotify="spotify --force-device-scale-factor=2.0"
alias vi="vim"
alias pvim="PYTHONPATH=$(pwd) vim"
alias pgvim="PYTHONPATH=$(pwd) gvim"
alias p="python"
alias grep="grep --color=auto"
alias zshcolors='for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done'
alias sudo="nocorrect sudo"
alias dirh="dirs -v"
alias cdh="dirs -v"
alias reflectarch="sudo /usr/bin/reflector --protocol https --latest 30 --number 20 --sort rate --save /etc/pacman.d/mirrorlist"
alias did="vim +'normal Go' +'r!date' ~/did.txt"
alias gitlines="git ls-files | while read f; do git blame -w -M -C -C --line-porcelain "$f" | grep -I '^author '; done | sort -f | uniq -ic | sort -nr"
alias open="xdg-open"
alias ssh-weechat="echo -e '\033]2;'weechat'\007'; ssh adam@adamatom.com -t screen -D -RR weechat weechat"
alias pipenv="nocorrect pipenv"
alias tmux="env TERM=tmux-256color tmux"
alias backupb2="rclone sync /home/adam b2:Pascal-Backup --transfers 32 --filter-from /home/adam/rclone-files.txt --fast-list -P -L --b2-hard-delete"
alias pip="pip3"
alias gs="git status"
alias gf="git fetch -Ppat"
alias sml="rlwrap sml"
alias vc="vim ~/.vimrc"
alias vp="vim ~/.vimrc.plugins"
alias gitk="gitk &"

launch() {
    "$@" 2>/dev/null & disown
}

gdiff () {
    diff -u $@ | colordiff | less -R;
}

checkbranch() {
    for dir in *; do
        if [ -d "$dir/.git" ]; then
            branch=$(git -C $dir branch | grep \* | sed "s/\* //")
            printf "%-25s%-12s\n" "$dir" "$branch"
        fi
    done
}

checkrepos() {
    for dir in *; do
        if [ -d "$dir/.git" ] && [ ! -f "$dir/.dontcheck" ]; then
            branch=$(git -C $dir branch | grep \* | sed 's/\* //')
            localstate=$(git -C $dir rev-parse HEAD)
            remotestate=$(git -C $dir ls-remote $(git -C $dir rev-parse --abbrev-ref @{u} | sed 's/\// heads\//g') | cut -f1)

            [ "$localstate" = "$remotestate" ] && state="OK" || state="Behind"
            printf "%-30s%-30s%-12s\n" "$dir" "$branch" "$state"
        fi
done
}

rmkey() {
    sed -i "$1d" "${HOME}/.ssh/known_hosts"
}

config() {
    if [[ $@ =~ "^clean" ]]; then
        echo "LOLLLLLLL, you almost blew up your home directory"
    else
        git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
    fi
}

enable_vivado() {
    if [[ "$#" == "0" ]]; then
        echo "usage: enable_vivado <net_adaptor>"
        echo "candidate net_adaptors:\n"
        ip a | sed -n -e 's/^[0-9]: \(.*\):.*/\1/p' | sed -n -e '/lo/!p'
    else
        sudo ip link set dev $1 down
        sudo ip link set $1 address d6:db:e9:70:7b:16
        echo "$1" > /tmp/vivado_link
    fi
}

disable_vivado() {
    if [[ ! -f /tmp/vivado_link ]]; then
        echo "Vivado network adapter not detected"
    else

        VIVADO_LINK=$(cat /tmp/vivado_link)
        sudo ip link set $VIVADO_LINK address e4:a7:a0:3a:f7:73
        sudo ip link set dev $VIVADO_LINK up
        rm /tmp/vivado_link
    fi
}

zshrecompile() {
    autoload -U zrecompile
    rm -f ~/.zsh/*.zwc
    [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
    [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old

    for f in ~/.zsh/**/*.zsh; do
        [[ -f $f ]] && zrecompile -p $f
        [[ -f $f.zwc.old ]] && rm -f $f.zwc.old
    done

    [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
    [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old

    source ~/.zshrc
}
