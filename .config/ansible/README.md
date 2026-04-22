# Setup

## Install pipx

https://pipx.pypa.io/stable/

https://pypi.org/project/pipx-in-pipx/

```bash
python3 -m pip install --user pipx-in-pipx
```

## Install Ansible

https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

```bash
pipx install --include-deps ansible-core
```

## Install dependencies

```bash
ansible-galaxy collection install --requirements-file requirements.yaml
```
Not needed if you installed `ansible` above rather than just `ansible-core`.

## Run playbook

```bash
ansible-playbook -v playbook.yaml --ask-become-pass
```


# Troubleshooting

## ERROR: Ansible could not initialize the preferred locale: unsupported locale setting

Likely need to install locales:

```bash
sudo apt install locales-all
```

Then restart the shell.


## Can't start neovim due to glibc being too old

### Symptom

Errors like the following indicate that the `glibc` on your machine is too old to run the neovim appimage:

```
$ nvim --version
/tmp/.mount_nvimLNDJOE/usr/bin/nvim: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.33' not found (required by /tmp/.mount_nvimLNDJOE/usr/bin/nvim)
/tmp/.mount_nvimLNDJOE/usr/bin/nvim: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.32' not found (required by /tmp/.mount_nvimLNDJOE/usr/bin/nvim)
/tmp/.mount_nvimLNDJOE/usr/bin/nvim: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by /tmp/.mount_nvimLNDJOE/usr/bin/nvim)
```

### Fix

Download the appimage from: https://github.com/neovim/neovim-releases/releases

Then copy/move to `/usr/local/bin/nvim`, and `sudo chmod +x` it.

These are built against older `glibc` versions (v2.17 as of this writing).


## Can't start tree-sitter due to glibc being too old

### Symptom

Errors like the following indicate that the `glibc` on your machine is too old to run the compiled `tree-sitter` rust
executable:

```
$ tree-sitter --version
tree-sitter: /lib/x86_64-linux-gnu/libm.so.6: version `GLIBC_2.35' not found (required by tree-sitter)
tree-sitter: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.32' not found (required by tree-sitter)
tree-sitter: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.33' not found (required by tree-sitter)
tree-sitter: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by tree-sitter)
tree-sitter: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.39' not found (required by tree-sitter)
```

### Fix

The fix is to build the executable ourselves, which will ensure it will link against our older `glibc`.

Ensure rust toolchain is installed: https://rustup.rs/

Clone `tree-sitter` if not already done so:

```bash
mkdir --parents ~/work
cd ~/work
git clone https://github.com/tree-sitter/tree-sitter
```

Checkout the tag we specify in the [neovim vars](roles/neovim/vars/main.yaml):

```bash
cd ~/work/tree-sitter
git fetch origin
git checkout "v$(yq eval '.neovim.tree_sitter.version' ~/.config/ansible/roles/neovim/vars/main.yaml)"
```

Build the `tree-sitter` CLI:

```bash
cargo build --release --package tree-sitter-cli
```

Install:

```bash
cp target/release/tree-sitter ~/.local/bin/tree-sitter
```
