# ===== Basics
setopt no_beep  # dont beep on error
unsetopt flow_control # disable ^q/^s
setopt interactive_comments # Allow comments even in interactive shells

# ===== Changing Directories
setopt auto_cd # If you type foo, and it isnt a command, and it is a directory in your cdpath, go there
setopt cdablevarS # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups # dont push multiple copies of the same directory onto the directory stack

setopt autopushd  # make cd act like pushd automatically
setopt pushdminus  # swap the +/- meaning in cd -1, it matches the output of dirs better
setopt pushdsilent  # dont print dir when we pushd
setopt pushdtohome  # put home dir on stack when we type 'cd', since cd now does a pushd

# ===== Expansion and Globbing
setopt extended_glob # treat #, ~, and ^ as part of patterns for filename generation

# ===== History
setopt append_history # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history # save timestamp of command and duration
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_fcntl_lock # Dont use zsh adhoc locking mechanism, use OS's fcntl for HISTFILE lock
setopt hist_find_no_dups # When searching history dont display results already cycled through twice
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
setopt hist_verify # dont execute, just expand history
setopt share_history # imports new commands and appends typed commands to history

# ===== Completion 
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word    
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word # Allow completion from within a word/phrase

unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
setopt correct # spelling correction for commands
setopt correctall # spelling correction for arguments

# ===== Prompt
setopt prompt_subst # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt transient_rprompt # only show the rprompt on the current prompt
setopt IGNORE_EOF # disable ctrl-d to logout

# ===== Scripts and Functions
setopt multios # perform implicit tees or cats when multiple redirections are attempted

