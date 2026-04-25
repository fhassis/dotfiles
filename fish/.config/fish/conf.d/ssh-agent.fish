# Configure SSH agent depending on environment
if status is-interactive
    if test -n "$WSL_DISTRO_NAME"
        # Running inside WSL → use Windows OpenSSH agent
        set -gx SSH_AUTH_SOCK /mnt/c/Users/fhassis/AppData/Local/ssh-agent/ssh-agent.sock
    else
        # Native Linux → use local ssh-agent socket
        set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    end
end
