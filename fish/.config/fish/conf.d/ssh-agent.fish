# ~/.config/fish/conf.d/ssh-agent.fish

if status is-interactive
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

    # Start agent only if unreachable; exit 1 means running but no keys yet
    ssh-add -l >/dev/null 2>&1
    if test $status -eq 2
        rm -f "$SSH_AUTH_SOCK"
        ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
    end
end
