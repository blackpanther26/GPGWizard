#!/bin/bash

list_gpg_keys() {
    echo
    echo "$(figlet -f digital "List GPG Keys")" | lolcat
    gpg --list-secret-keys --keyid-format LONG
    echo
    printf '\n%s\n' "Which key do you want to list the pgp key for? (Enter 1/2/3/...)"
    read n
    keyCount=$(gpg --list-secret-keys --keyid-format=long | awk '$1 ~ /sec/ {print $2}' | awk -F "/" '{print $2}' | wc -l)
    if ! [[ "$n" =~ ^[-+]?[0-9]+$ ]]; then
    echo "Error: Not a valid integer."
    elif [[ "$n" -gt "$keyCount" || ! "$n" =~ ^[0-9]+$ ]]; then
    echo "Error"
    else
    keyId=$(gpg --list-secret-keys --keyid-format=long | awk '$1 ~ /sec/ {print $2}' | awk -F "/" '{print $2}' | sed -n "${n}p")
    gpg --armor --export $keyId
    fi
}

delete_gpg_key() {
    echo
    echo "$(figlet -f digital "Delete GPG Key")" | lolcat
    echo "GPG keys:"
    gpg --list-secret-keys --keyid-format LONG
    echo
    printf '\n%s\n' "Which key do you want to delete (Enter 1/2/3/...)"
    read n
    keyCount=$(gpg --list-secret-keys --keyid-format=long | awk '$1 ~ /sec/ {print $2}' | awk -F "/" '{print $2}' | wc -l)
    if ! [[ "$n" =~ ^[-+]?[0-9]+$ ]]; then
    echo "Error: Not a valid integer."
    elif [[ "$n" -gt "$keyCount" || ! "$n" =~ ^[0-9]+$ ]]; then
    echo "Error"
    else
    keyId=$(gpg --list-secret-keys --keyid-format=long | awk '$1 ~ /sec/ {print $2}' | awk -F "/" '{print $2}' | sed -n "${n}p")
    gpg --delete-secret-key $(echo $keyId)
    gpg --delete-key $(echo $keyId)
    fi
}

create_gpg_key() {
    echo
    echo "$(figlet -f digital "Create New GPG Key")" | lolcat
    gpg --full-generate-key
    echo "Full GPG key created."
}

set_gpg_key_for_git() {
    echo
    echo "$(figlet -f digital "Set GPG Key for Git")" | lolcat
    echo "GPG keys:"
    gpg --list-secret-keys --keyid-format LONG
    echo
    printf '\n%s\n' "Which key do you want to use for signing commits (Enter 1/2/3/...): "
    read num
    keyCount=$(gpg --list-secret-keys --keyid-format=long | awk '$1 ~ /sec/ {print $2}' | awk -F "/" '{print $2}' | wc -l)
    if ! [[ "$n" =~ ^[-+]?[0-9]+$ ]]; then
    echo "Error: Not a valid integer."
    elif [[ "$num" -gt "$keyCount" || ! "$num" =~ ^[0-9]+$ ]]; then
    echo "Error"
    else
    keyId=$(gpg --list-secret-keys --keyid-format=long | awk '$1 ~ /sec/ {print $2}' | awk -F "/" '{print $2}' | sed -n "${num}p")
    git config --global user.signingkey "$keyId"
    git config --global commit.gpgsign true
    gpg --armor --export $keyId
    echo "Paste the above key on your GitHub."
    echo "GPG key $keyId set for Git commits."
    fi  
}

