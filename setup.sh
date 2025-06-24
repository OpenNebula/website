#!/usr/bin/env bash

set -euo pipefail

OS="$(uname -s)"
ARCH="$(uname -m)"

install_hugo_mac() {
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    wget https://github.com/gohugoio/hugo/releases/download/v0.145.0/hugo_extended_0.145.0_darwin-universal.tar.gz
    tar -xzf hugo_extended_0.145.0_darwin-universal.tar.gz
    sudo mv hugo /usr/local/bin/
    cd -
    rm -rfd "$TMP_DIR"
    hugo version
}

install_hugo_linux() {
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"

    case "$ARCH" in
    aarch64)
        FILE="hugo_extended_0.145.0_Linux-arm64.tar.gz"
        ;;
    x86_64)
        FILE="hugo_extended_0.145.0_Linux-amd64.tar.gz"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
    esac

    wget "https://github.com/gohugoio/hugo/releases/download/v0.145.0/$FILE"

    tar -xzf "$FILE"
    sudo mv hugo /usr/local/bin/
    cd -
    rm -rfd "$TMP_DIR"
    hugo version
}

install_homebrew_and_go_mac() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install go
}

install_go_linux() {
    sudo apt update
    sudo apt install -y golang
}

install_node_and_postcss() {
    export NVM_DIR="$HOME/.nvm"
    if [ ! -d "$NVM_DIR" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    fi

    if [ -s "$NVM_DIR/nvm.sh" ]; then
        # shellcheck disable=SC1091
        . "$NVM_DIR/nvm.sh"
    fi

    nvm install 22
    nvm alias default 22
    node -v
    npm install -D postcss postcss-cli
}

case "$OS" in
Darwin)
    echo "Installing Hugo for macOS..."
    install_hugo_mac
    echo "Installing Homebrew and Go for macOS..."
    install_homebrew_and_go_mac
    ;;
Linux)
    echo "Installing Hugo for Linux..."
    install_hugo_linux
    echo "Installing Go for Linux..."
    install_go_linux
    ;;
*)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "Installing Node.js and PostCSS..."
install_node_and_postcss

echo "Environment setup complete."
