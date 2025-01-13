# Setup

## Install pipx

https://pipx.pypa.io/stable/

For Ubuntu 23.04 or above:
```bash
sudo apt update
sudo apt install python3-pipx
pipx ensurepath
```

Otherwise:
```bash
python3 -m pip install --user pipx
python3 -m pipx ensurepath
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
