#!/bin/bash
source ./configure.sh
source ./utils.sh
display_menu() {
    (echo "$(figlet -c "GPG Wizard")"
     printf '\n%s\n\n' ===============================================================================| lolcat
     printf '\n%s\n' "1) List GPG keys"
     printf '\n%s\n' "2) Delete a GPG key"
     printf '\n%s\n' "3) Create a new GPG key"
     printf '\n%s\n' "4) Set GPG key for Git"
     printf '\n%s\n' "5) Exit"
     printf '\n%s\n\n' ===============================================================================) | lolcat
}
while true; do
    display_menu
    (printf '\n%s\n' "Enter your choice (1-5): ") | lolcat
    read choice
    case $choice in
        1) list_gpg_keys ;;
        2) delete_gpg_key ;;
        3) create_gpg_key ;;
        4) set_gpg_key_for_git ;;
        5) break ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done