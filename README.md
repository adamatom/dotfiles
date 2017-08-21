*Stolen from https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/*
# Setup
```bash
git init --bare $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
```

# Example usage
```bash
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```


# Installation on new machine
Prior to the installation make sure you have committed the alias to your .bashrc or .zsh:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```
And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:

```bash
echo ".cfg" >> .gitignore
```

Now clone your dotfiles into a bare repository in a "dot" folder of your $HOME:

```bash
git clone --bare <git-repo-url> $HOME/.cfg
```

Define the alias in the current shell scope:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Checkout the actual content from the bare repository to your $HOME:

```bash
config checkout
```

The step above might fail with a message like:

```bash
error: The following untracked working tree files would be overwritten by checkout:
    .bashrc
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```

This is because your $HOME folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:

```bash
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```

Re-run the check out if you had problems:

```bash
config checkout
```

Set the flag showUntrackedFiles to no on this specific (local) repository:

```bash
config config --local status.showUntrackedFiles no
```

You're done, from now on you can now type config commands to add and update your dotfiles:

```bash
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```


