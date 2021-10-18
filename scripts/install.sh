#!/bin/bash
CONFIG="$HOME/.config"
SYSTEMPGK="sudo lightdm lightdm-gtk-greeter openbox xorg-xinit xcompmgr feh "
PROGRAMPGK="git alacritty fish gummi thunar discord thunderbird firefox-developer-edition birdfont nethack ranger asciiquarium archey3 code figlet"
DEVPGK="--needed base-devel"

RUSTUP="curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

installScript(){
    echo "Install default $1 packages for Arch?";
    echo "Contains: $2";
    confirm "pacman -S $2"
}

installEww(){
    echo "Install EWW ( ElKowar's Wacky Widget )"
    local GIT="git clone https://github.com/elkowar/eww"
    BIN=$(echo -n "{line[@]}" | exists "$HOME/.bin" )
    CARGO=$(echo -n "{line[@]}" | exists "$HOME/.cargo" )
    if [[ "$CARGO" != "dir" ]]; then
        echo "Install Rustup"
        confirm "$RUSTUP"
    fi
    GIT=$(echo -n "{line[@]}" | exists "$HOME/git" )
    if [[ "$GIT" != "dir" ]]; then
        echo "Make git dir?"
        cd ~
        pwd
        confirm "mkdir git"
        cd ~/git
        echo "Build EWW"
        confirm "~/.cargo/bin/cargo build --release"
        cd target/release
        chmod -x ./eww
        echo "Move EWW to .bin?"
        confirm "mkdir ~/.bin && cp ~/git/eww/target/release/eww ~/.bin"
    fi
}

confirm(){
    read -p "( Y/n ) ";
    echo ''
    case "$REPLY" in
        "y" | "Y" )
            eval "${@:1}"
            exit;;
        *)
            exit;;
    esac
}

exists(){
    if [ -d "$1" ]; then
        echo 'dir'
    elif [ -f "$1" ]; then
        echo 'file'
    else
        echo 0
    fi
}

case "$1" in
    "-is" | "--installSystem" )
        installScript 'system' "$SYSTEMPGK"
        exit;;
    "-ip" | "--installPrograms" )
        installScript 'programs' "$PROGRAMPGK"
        exit;;
    "-id" | "--installDevel" )
        installScript 'dev tools' "$DEVPGK"
        exit;;
    "-e" | "--exists" )
        exists "$2"
        exit;;
    "-ec" | "--existsConfig" )
        exists "$CONFIG/$2"
        exit;;
    "-d" )
        confirm "$2"
        exit;;
    *)
        echo "The following parameter are available to use."
        echo "This installer is for my arch setup, using openbox."
        echo ""
        echo "[ -is | --installSystem ]                 Installs the system components that i use."
        echo "[ -ip | --installPrograms ]               Installs the programs that i want by default."
        echo "[ -id | --installDevel ]                  Installs base devel."
        echo "[ -e  | --exists ] { FOLDER|FILE }        Checks if folder/file exists. Or returns 0."
        echo "[ -ec | --existsConfig ] { FOLDER|FILE }  Checks if folder/file exists. Or returns 0."
        echo ""
        exit;;
esac