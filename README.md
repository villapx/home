## Linux Home Folder

Before opening VIM for the first time, run:

```bash
mkdir -p .vim/bundle
cd .vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git
vim +PluginInstall +qall
```

###TODO:

* Make sure we're being careful with how we set the TMux status bar colors--
only set colors that are available on the current terminal
