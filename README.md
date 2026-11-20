# dotfiles

My terminal, the same on a Linux workstation (native or WSL, Debian/Ubuntu) and
in [devcontainers](https://github.com/fhassis/devcontainer): fish, starship,
fzf, zoxide, eza, bat, fd, ripgrep, delta, tmux and neovim, all in
[Catppuccin Mocha](https://catppuccin.com).

## Install

**Workstation:**

```sh
git clone https://github.com/fhassis/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

Then set your terminal's profile to run `fish` (Windows Terminal: `wsl.exe -d <distro> fish`;
Ghostty: `command = fish`). The script doesn't `chsh`: bash stays the login
shell, so scripts that expect it keep working. You also need a
[Nerd Font](https://www.nerdfonts.com) in the terminal.

**Devcontainers (VS Code):** in your *user* settings:

```jsonc
"dotfiles.repository": "fhassis/dotfiles",
"dotfiles.installCommand": "install.sh"
```

Every new container clones this repo into `~/dotfiles` and runs `install.sh`.

Run `install.sh` again after a pull. It is idempotent.

## What `install.sh` does

1. **Workstation only:** `apt install` fish and tmux if they are missing (asks for sudo).
2. **Links** every file under [`home/`](./home) to the same path in `$HOME`, one by one,
   never whole directories, so files the tools write (`fish_variables`...) stay out
   of the repo. An existing regular file is kept as `<file>.bak`. Links into this
   repo that no longer resolve (a file removed here, or an older stow layout) are removed.
3. **Tools:** installs [mise](https://mise.jdx.dev) if missing (the devcontainer
   image already has it), then `mise install` for the tools in
   [`~/.config/mise/config.toml`](./home/.config/mise/config.toml), all latest,
   in the home, no root. Then builds bat's theme cache.
4. **Catppuccin for tmux and neovim:** clones them at a pinned tag (no plugin managers).
5. **WSL only:** installs [wsl2-ssh-agent](https://github.com/mame/wsl2-ssh-agent).

## What you get

| | |
| :--- | :--- |
| Prompt | starship, nerd-font symbols |
| `ls` `ll` `la` `lt` | eza: plain, long, long with hidden files, tree |
| `cat` | bat |
| `z <dir>` / `zi` | zoxide, `zi` picks with fzf and an eza tree preview |
| Ctrl+T / Ctrl+R / Alt+C | fzf: files (fd, bat preview), history, cd (eza tree preview) |
| `f` | fuzzy-find a file, open it in nvim |
| `rgf <text>` | ripgrep → fzf (bat preview at the line) → nvim at that line |
| `git diff/log/show` | delta, side by side with line numbers |
| `man` | bat-colored |
| `$EDITOR` | nvim: plain options and Catppuccin, no plugins |
| tmux | mouse, vi copy mode, windows from 1, splits keep the directory, Catppuccin status |

Fish completions in [`completions/`](./home/.config/fish/completions) are one
line each: they ask the installed binary on the first Tab, so they always match
its version and nothing generated is committed.

## SSH agent

[`50-ssh-agent.fish`](./home/.config/fish/conf.d/50-ssh-agent.fish) never starts an agent:

- **Native Linux:** the desktop session's agent (seahorse / gcr).
- **Devcontainer:** VS Code forwards the host's agent.
- **WSL:** bridges to the Windows OpenSSH agent, so keys are added once, on Windows,
  and work in WSL and in containers opened from Windows. On Windows, once:
  ```powershell
  Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service
  ssh-add $env:USERPROFILE\.ssh\id_ed25519
  ```

## Adding things

- **A tool:** a line in [`mise/config.toml`](./home/.config/mise/config.toml), then `install.sh`.
- **A config file:** put it under `home/` at its path relative to `$HOME`, then `install.sh`.
- **Development toolchains** (node, uv, kubectl...) belong to the devcontainer image, not here.
