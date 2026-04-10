# configure podman socket to emulate docker socket
set -gx DOCKER_HOST unix://$XDG_RUNTIME_DIR/podman/podman.sock
set -gx DOCKER_SOCK $XDG_RUNTIME_DIR/podman/podman.sock
