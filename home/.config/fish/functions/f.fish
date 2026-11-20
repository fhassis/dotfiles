function f --description 'Fuzzy-find a file and open it in $EDITOR'
    set -l file (fzf --preview 'bat --color=always --style=numbers --line-range=:300 {}')
    and $EDITOR $file
end
