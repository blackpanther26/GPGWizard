#!/bin/bash
source ./configure.sh

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

list_gpg_keys() {
    echo
    echo "$(figlet -f digital "List GPG Keys")" | lolcat
    gpg --list-secret-keys --keyid-format LONG
    echo
}

delete_gpg_key() {
    echo
    echo "$(figlet -f digital "Delete GPG Key")" | lolcat
    echo "GPG keys:"
    gpg --list-secret-keys --keyid-format LONG
    echo
    printf '\n%s\n' "Which key do you want to delete (Enter 1/2/3/...)"
    read n
    keyId=$(gpg --list-secret-keys --keyid-format=long | awk '$1 ~ /sec/ {print $2}' | awk -F "/" '{print $2}' | sed -n "${n}p")  
	gpg --delete-secret-key $(echo $keyId)
	gpg --delete-key $(echo $keyId)
}

create_gpg_key() {
    echo
    echo "$(figlet -f digital "Create New GPG Key")" | lolcat
    echo "Do you want to generate a default or a full GPG key?"
    read -p "Enter 'default' or 'full': " key_type
    if [ "$key_type" == "default" ]; then
        echo "Please enter your name and email address:"
        read -p "Name: " user_name
        read -p "Email: " user_email
        gpg --quick-generate-key "$user_name <$user_email>" default default never
        echo "Default GPG key created."
    elif [ "$key_type" == "full" ]; then  
        gpg --full-generate-key
        echo "Full GPG key created."
    else
        echo "Invalid choice. Please try again."
    fi
}

set_gpg_key_for_git() {
    echo
    echo "$(figlet -f digital "Set GPG Key for Git")" | lolcat
    echo "GPG keys:"
    gpg --list-secret-keys --keyid-format LONG
    echo
    printf '\n%s\n' "Which key do you want to use for signing commits (Enter 1/2/3/...): "
    read num
    keyId=$(gpg --list-secret-keys --keyid-format=long | awk '$1 ~ /sec/ {print $2}' | awk -F "/" '{print $2}' | sed -n "${num}p")
    git config --global user.signingkey "$keyId"
    git config --global commit.gpgsign true
    
    gpg --armor --export $keyId
    echo "paste the above key on your github."
    echo "GPG key $keyId set for Git commits."
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