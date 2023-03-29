# This is sourced once per login by zsh when logging in via non-graphical interactive login.
# .zshenv → [.zprofile if login] → [.zshrc if interactive] → [.zlogin if login] → [.zlogout sometimes]

# NOTE: /etc/profile is not a part of the regular list of startup files run for Zsh, but is sourced from
# /etc/zsh/zprofile in the zsh package. Users should take note that /etc/profile sets the $PATH variable
# which will overwrite any $PATH variable set in $ZDOTDIR/.zshenv. To prevent this, please set the $PATH
# variable in $ZDOTDIR/.zprofile.
if [ -f ~/.zshenv_custom ]; then
    source ~/.zshenv_custom
fi
export PATH=$HOME/.bin:$PATH
export PATH="/opt/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi/bin:$PATH"
