# use UTF-8 encoding
export LANG=en_US.UTF-8

# set important environment variables
export EDITOR=vim

# prevent "others" from getting write permission on created files
umask 2

# configure the 'less' pager
#   -Q: turn off the terminal bell
#   -R: allow ANSI color escape sequences to work
export LESS="$LESS -Q -R"

# source site-specific bash_profile file, if it exists and is readable
if [ -r ~/.bash_profile-site ]
then
    source ~/.bash_profile-site
fi

# if this is an interactive shell, source .bashrc
case "$-" in
    *i*) source ~/.bashrc
esac
