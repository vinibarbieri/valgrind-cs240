#!/bin/bash
IMAGE=cs240-env

# Folder that contains this script and the Dockerfile (works from any folder)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$SCRIPT_DIR/Dockerfile" ]; then
    echo "ERROR: Dockerfile not found in:"
    echo "    $SCRIPT_DIR"
    echo "Copy both linux_mac.sh and Dockerfile into the folder with your code."
    exit 1
fi

# Folder to share with Linux: the one given as argument, or the folder this script is in
CODE_DIR="${1:-$SCRIPT_DIR}"
if [ ! -d "$CODE_DIR" ]; then
    echo "ERROR: folder not found: $CODE_DIR"
    exit 1
fi
CODE_DIR="$(cd "$CODE_DIR" && pwd)"

# 1. Is Docker installed?
if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker is not installed."
    echo "Install Docker Desktop: https://www.docker.com/products/docker-desktop/"
    exit 1
fi

# 2. Is Docker running? If not, open Docker Desktop and wait for it
if ! docker info >/dev/null 2>&1; then
    if docker info 2>&1 | grep -qi "permission denied"; then
        echo "ERROR: your user is not allowed to use Docker. Run:"
        echo "    sudo usermod -aG docker \$USER"
        echo "then log out and log back in."
        exit 1
    fi

    echo "Docker is not running. Opening Docker Desktop..."
    echo "(If Docker Desktop shows a window asking you to accept terms or sign in, do it.)"
    if [ "$(uname)" = "Darwin" ]; then
        open -a Docker
    else
        systemctl --user start docker-desktop 2>/dev/null || sudo systemctl start docker
    fi

    printf "Waiting for Docker to start"
    for _ in $(seq 90); do
        docker info >/dev/null 2>&1 && break
        printf "."
        sleep 2
    done
    echo

    if ! docker info >/dev/null 2>&1; then
        echo "ERROR: Docker did not start."
        echo "Open Docker Desktop yourself, wait until it says 'Engine running',"
        echo "then run this script again."
        exit 1
    fi
fi

# 3. Build the Linux environment (slow only the first time)
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "First time setup: building the Linux environment."
    echo "This takes 1-3 minutes. Do not close this window."
    docker build -t "$IMAGE" "$SCRIPT_DIR" || BUILD_FAILED=1
else
    docker build -q -t "$IMAGE" "$SCRIPT_DIR" >/dev/null || BUILD_FAILED=1
fi
if [ -n "$BUILD_FAILED" ]; then
    echo "ERROR: could not build the Linux environment. Check your internet connection and try again."
    exit 1
fi

# 4. Warn if the shared folder has no C files (usually means wrong folder)
if [ -z "$(find "$CODE_DIR" -maxdepth 2 -name '*.c' -print -quit 2>/dev/null)" ]; then
    echo "WARNING: no .c files found in:"
    echo "    $CODE_DIR"
    echo "Copy linux_mac.sh and Dockerfile into the folder with your code and run it from there."
    read -r -p "Continue anyway? [y/N] " ANSWER
    [[ "$ANSWER" =~ ^[yY]$ ]] || exit 1
fi

echo "---------------------------------------------------"
echo "You are now inside Linux."
echo "Your folder:  $CODE_DIR"
echo "is available here as /code"
echo "To exit and return to your machine, type 'exit'."
echo "---------------------------------------------------"

# The -v flag mirrors the local folder into the container
docker run --rm -it -v "$CODE_DIR":/code "$IMAGE"
