# Editor and man pager, for scripts and git too.
if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
end

if type -q bat
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT -c
end
