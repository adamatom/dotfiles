# Setup terminal, and turn on colors
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export GOPATH=$HOME/.go
export PATH=$PATH:$HOME/.bin:$GOPATH/bin:/opt/Xilinx/Vivado/2016.2/bin/

export XLINIXD_LICENSE_FILE=2101@morph2
export XDG_DATA_DIRS=/usr/share:/usr/local/share

export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
