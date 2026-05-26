## Home Folder Config Files/Dotfiles

### clangd

```bash
sudo apt install clangd-18
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 100
```

### VIM

Before opening VIM for the first time, run:

```bash
mkdir -p .vim/bundle
cd .vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git
vim +PluginInstall +qall
```

