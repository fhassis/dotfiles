# ~/.config/fish/conf.d/ssh-agent.fish

if status is-interactive
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

    # ssh-add -l: 0 = agent has keys, 1 = agent running but empty, 2 = unreachable
    ssh-add -l >/dev/null 2>&1
    set -l agent_status $status

    if test $agent_status -eq 2
        rm -f "$SSH_AUTH_SOCK"
        ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
        set agent_status 1
    end

    if test $agent_status -eq 1; and test -f ~/.ssh/id_ed25519
        ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
    end
end
