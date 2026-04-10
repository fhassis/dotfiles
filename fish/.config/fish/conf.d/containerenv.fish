# Detect if the shell is running inside a container (Toolbx/Podman)
if test -f /run/.containerenv
    # Set icon for the Dev Container environment
    set -gx STARSHIP_DISTRO "📦"
else
    # Set icon for the Atomic Fedora Host
    set -gx STARSHIP_DISTRO "❄️"
end
