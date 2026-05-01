# dotfiles

Dotfiles for my linux setup.

> These files are expected to be installed using gnu *stow*.

# How to Install

From the project directory, install each configuration like below:

```bash
stow fish
```

No `-t` flag is needed because stow's default target is the **parent of the current directory**. This only works as long as the dotfiles repo lives directly inside `$HOME` (`~/dotfiles`). If you ever move it elsewhere (e.g. `/opt/dotfiles`), you must pass `-t ~` explicitly or add a `.stowrc` file.
