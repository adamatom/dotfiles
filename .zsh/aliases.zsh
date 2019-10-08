export LANG="en_US.UTF-8"

export GOPATH=$HOME/.go
export RUBYGEMPATH=$HOME/.gem/ruby/2.5.0/
export PATH=$PATH:$HOME/.bin:$GOPATH/bin:$RUBYGEMPATH/bin:/opt/Xilinx/Vivado/2016.2/bin/
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
export ENHANCD_DISABLE_DOT=0
export ENHANCD_DOT_ARG="../.."

alias ls="ls -lA --color=always --group-directories-first"
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
alias vl="vault login -method=ldap username=alabbe"
alias vv="vault write -field=signed_key ssh-iscm-signer/sign/ca-sign public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub"
alias pipenv="nocorrect pipenv"
alias tmux="env TERM=tmux-256color tmux"
alias backupb2="rclone sync /home/adam b2:Pascal-Backup --transfers 32 --filter-from /home/adam/rclone-files.txt --fast-list -P -L --b2-hard-delete"


# -u 1000:1000 docker.is.idexx.com/buildroot-minimal:1.2.0 \
dockbuild() {
    docker run --hostname build --name build --rm -it \
        -v /home/adam/.ssh:/home/br-user/.ssh \
        -v /home/adam/projects/idexx/acadia:/tmpfs \
        -v /home/adam/.buildroot-ccache:/home/br-user.buildroot-ccache \
        -v /home/adam/.buildroot-autoconf-cache/:/home/br-user/.buildroot-autoconf-cache \
        -v /home/adam/.buildroot-dl-cache/:/home/br-user/.buildroot-dl-cache \
        -v $SSH_AUTH_SOCK:/ssh-agent \
        -e SSH_AUTH_SOCK=/ssh-agent \
        -u 1000:1000 docker.is.idexx.com/buildroot-publish:1.1.1 \
        /bin/bash -c "ssh-add -l; cd /tmpfs/buildroot; $1"
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
        /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
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
