# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
export LANG="en_US.UTF-8"

export GOPATH=$HOME/.go
export RUBYGEMPATH=$HOME/.gem/ruby/2.5.0/

# Load home-manager if it is installed.
if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

PATH="$PATH:$HOME/.rye/shims"

# Always want these, no condition:
PATH="$PATH:$GOPATH/bin:$RUBYGEMPATH/bin:$HOME/projects/tek-linux/node_modules/.bin"

# Only add if the dirs exist:
[ -d "$HOME/bin" ]        && PATH="$PATH:$HOME/bin"
[ -d "$HOME/.local/bin" ] && PATH="$PATH:$HOME/.local/bin"
[ -d "$HOME/.bin" ]       && PATH="$PATH:$HOME/.bin"

export PATH

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/.local/share/../bin/env" ] && . "$HOME/.local/share/../bin/env"

# disable paging for git delta.
export DELTA_PAGER=""
export LESS='--quit-if-one-screen --ignore-case --status-column --chop-long-lines --long-prompt --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --window=-4'
export MANPAGER='less +Gg'
export FZF_DEFAULT_COMMAND='rg --hidden --no-ignore -l ""'
export MCFLY_RESULTS=100
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_RESULTS_SORT=LAST_RUN
export PATH=$HOME/.bin:$PATH
if command -v gsettings >/dev/null 2>&1; then
  theme=$(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null | tr -d "'")
  [ -n "$theme" ] && export XCURSOR_THEME="$theme"
fi
