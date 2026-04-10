# Initialize Starship prompt if the binary is available
if type -q starship
    starship init fish | source
end
