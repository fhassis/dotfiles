# SSH agent. This file never starts an agent of its own:
#  - native Linux: the desktop session provides it (seahorse / gcr)
#  - devcontainer: VS Code forwards the host's agent
#  - WSL: bridge to the Windows OpenSSH agent, so keys are added once, on Windows.
#    -format fish because $SHELL stays bash (fish is only the terminal's command).
if set -q WSL_DISTRO_NAME; and type -q wsl2-ssh-agent
    wsl2-ssh-agent -format fish | source
end
