export LANG="en_US.UTF-8"

export GOPATH=$HOME/.go
export RUBYGEMPATH=$HOME/.gem/ruby/2.5.0/
export PATH=$PATH:$HOME/.bin:$GOPATH/bin:$RUBYGEMPATH/bin:/opt/Xilinx/Vivado/2016.2/bin/
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
export ENHANCD_DISABLE_DOT=1

alias ls="ls -lA --color=always --group-directories-first"
alias gvim="gvim $* 2>/dev/null"
alias pyclean="find . | grep -E \"(__pycache__|\.pyc|\.pyo$)\" | xargs rm -rf"
alias spotify="spotify --force-device-scale-factor=2.0"
alias acadia_docker="docker run -ti --name acadia --hostname acadia -v /home/adam/projects/idexx:/src -v /home/adam/.ssh:/home/build/.ssh --rm --privileged embedded.idexxi.com:5012/acadia-build bash"
alias checkbranch='for dir in *; do if [ -d "$dir/.git" ]; then branch=$(git -C $dir branch | grep \* | sed "s/\* //"); printf "%-25s%-12s\n" "$dir" "$branch"; fi; done'
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
alias dockbuild="nocorrect docker run --hostname build --name build --rm -it -v /home/adam/projects/idexx/acadia/:/acadia -v /home/adam/projects/idexx/acadia/.buildroot-ccache:/.buildroot-ccache -u 1000:1000 buildroot/base:20180925.1553 /bin/bash -c "



function rmkey() {
    sed -i "$1d" "${HOME}/.ssh/known_hosts"
}

function config() {
    if [[ $@ =~ "^clean" ]]; then
        echo "LOLLLLLLL, you almost blew up your home directory"
    else
        /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
    fi
}

function enable_vivado() {
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

function disable_vivado() {
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
