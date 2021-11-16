# use UTF-8 encoding
export LANG=en_US.UTF-8

# set important environment variables
export EDITOR=vim

# prevent "others" from getting write permission on created files
umask 2

if [[ -n "$DISPLAY" ]]; then
    xset r rate 200 35
fi

# source site-specific bash_profile file, if it exists and is readable
if [ -r ~/.bash_profile-site ]
then
    source ~/.bash_profile-site
fi

# if this is an interactive shell, source .bashrc
case "$-" in
    *i*) source ~/.bashrc
esac
