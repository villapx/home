# Home Folder Config Files/Dotfiles

## Neovim

### clangd

```bash
sudo apt install clangd-18
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 100
```

### csharp-ls

Install .NET SDK, for example using the "scripted install" (`dotnet-install.sh`).
See: https://learn.microsoft.com/en-us/dotnet/core/install/linux

For example, to install [.NET 8.0](https://dotnet.microsoft.com/en-us/download/dotnet/8.0):

```bash
./dotnet-install.sh --version 8.0.421
```

This installs the SDK into the directory `~/.dotnet`.

Then, to install `csharp-ls`:

```bash
dotnet tool install --global csharp-ls
```

Depending on the .NET SDK version, the `csharp-ls` version may need to be specified. Per the
[releases page](https://github.com/razzmatazz/csharp-language-server/releases), the latest `csharp-ls` version that
supports .NET 8.0 is version `0.16.0`:

```bash
dotnet tool install --global --version 0.16.0 csharp-ls
```

## VIM

Before opening VIM for the first time, run:

```bash
mkdir -p .vim/bundle
cd .vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git
vim +PluginInstall +qall
```

