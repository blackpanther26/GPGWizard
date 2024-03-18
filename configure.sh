#!/bin/bash

install_on_debian() {
    echo "Installing lolcat and figlet on Debian-based system..."
    sudo apt-get update
    sudo apt-get install -y lolcat figlet
}

install_on_macos() {
    echo "Installing lolcat and figlet on macOS..."
    brew install lolcat figlet
}

check_os_and_install() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        install_on_debian
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        install_on_macos
    else
        echo "Unsupported operating system. Please install lolcat and figlet manually."
        exit[0]
    fi
}

if ! command -v lolcat &> /dev/null || ! command -v figlet &> /dev/null; then
    check_os_and_install
fi