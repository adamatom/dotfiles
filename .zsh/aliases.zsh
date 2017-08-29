alias ls="ls -la --color"
alias gvim="gvim $* 2>/dev/null"
alias pyclean="find . | grep -E \"(__pycache__|\.pyc|\.pyo$)\" | xargs rm -rf"
alias spotify="spotify --force-device-scale-factor=2.0"
alias acadia_docker="docker run -ti --name acadia --hostname acadia -v /home/adam/projects/idexx:/src -v /home/adam/.ssh:/home/build/.ssh --rm --privileged embedded.idexxi.com:5012/acadia-build bash"
alias enable_vivado="sudo ip link set dev wifi0 down; sudo ip link set wifi0 address d6:db:e9:70:7b:16"
alias disable_vivado="sudo ip link set wifi0 address e4:a7:a0:3a:f7:73; sudo ip link set dev wifi0 up"
alias checkbranch='for dir in *; do if [ -d "$dir/.git" ]; then branch=$(git -C $dir branch | grep \* | sed "s/\* //"); printf "%-25s%-12s\n" "$dir" "$branch"; fi; done'
alias vi="vim"
alias grep="grep --color=auto"
alias zshcolors='for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done'
alias sudo="nocorrect sudo"
alias dirh="dirs -v"

config() {
    if [[ $@ =~ "^clean" ]]; then
        echo "LOLLLLLLL, you almost blew up your home directory"
    else
        /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
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
