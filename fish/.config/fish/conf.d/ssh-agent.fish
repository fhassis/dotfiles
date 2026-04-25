# ~/.config/fish/conf.d/ssh-agent.fish

if status is-interactive
    # Define the local Linux socket path
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

    # Start the agent only if the socket isn't already active
    if not ss -ax | grep -q "$SSH_AUTH_SOCK"
        rm -f "$SSH_AUTH_SOCK"
        eval (ssh-agent -c -a "$SSH_AUTH_SOCK") > /dev/null
    end
end
