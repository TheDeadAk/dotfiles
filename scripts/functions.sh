#!/bin/bash

# Checks the screen resolution and runs function according to the result
checkScreen(){
    local res=$(xrandr -q | grep "*")

    case "$res" in
        *"x1014"*)
            echo "1280x1024";;
        *"x1080"*)
            echo "1920x1080";;
        *"x1440"*)
            echo "2560x1440";;
    esac
}

startSSHAgent(){
    ssh-agent /usr/bin/fish
}
addSSHKey(){
    ssh-add /home/td/.ssh/private
}
getMargin(){
    # Openbox get margins
    local conf=~/.config/openbox/rc.xml
    if [[ ! -f "$conf" ]]; then
        conf=/etc/xdg/openbox/rc.xml    
    fi

    local cat=$(cat "$conf" | grep "<$@>" | grep -Eo '[0-9]{1,4}')
    echo "$cat"
}

runningProcess(){
    local process=$(wmctrl -lx | grep "$@" | wc -l)
    echo "$process"
}

run(){
    eval $@ &
    echo "RUNNING $@"
    exit
}

tilingLeft(){
    echo "$@"
    local TOP_MARGIN="$(sh ~/scripts/functions -getMargin top)"
    local LEFT_MARGIN="$(sh ~/scripts/functions -getMargin left)"
    local RIGHT_MARGIN="$(sh ~/scripts/functions -getMargin right)"
    local BOTTOM_MARGIN="$(sh ~/scripts/functions -getMargin bottom)"
    if [[ -n "$1" ]]; then
        local TITLE_BAR_HEIGHT="$1"
    else 
        local TITLE_BAR_HEIGHT=0
    fi
    if [[ -n "$2" ]]; then
        local USELESS_GAPS="$2"
    else
        local USELESS_GAPS=0
    fi

    local MASTER_WIDTH="$(xwininfo -root | grep 'Height:' | awk '{print $2}')"
    local MASTER_HEIGHT="$(xwininfo -root | grep 'Width:' | awk '{print $2}')"
    echo "READY"
    echo "TOP | LEFT | RIGHT | BOTTOM | TITLE BAR | GAP | M WIDTH | H HEIGHT"
    echo "$TOP_MARGIN $LEFT_MARGIN $RIGHT_MARGIN $BOTTOM_MARGIN $TITLE_BAR_HEIGHT $USELESS_GAPS $MASTER_WIDTH $MASTER_HEIGHT"
}

keybindings(){
    if command -v firefox &> /dev/null; then
        __browser="firefox"
    elif command -v min &> /dev/null; then
        __browser="min"
    elif command -v firefox-developer-edition &> /dev/null; then
	__browser="firefox-developer-edition"
    else
	echo "No browser fund. Installing one"
	eval "sudo pacman -S firefox"
        __browser="$__term sudo pacman -S firefox"
    fi
    if command -v kitty &> /dev/null; then
        __term="kitty"
    elif command -v alacritty; then
        __term="alacritty"
    fi
    case "$@" in
        "t"|"term"|"terminal")
            eval $__term
            exit;;
        "b"|"browser")
            eval $__browser
            exit;;
        *)
            echo "$@"
    esac
}

default(){
    echo ""
    echo "This is the functions available in this file."
    echo ""
    echo "  --r  | -run                 run specific applications"
    echo "  --rp | -runningProcess      lookup specificed process"
    echo "  --gm | -getMargin           gets margin from openbox configuration file ( left | right | top | bottom )"
    echo "  --cs | -checkScreen         checks screenresolution and runs function"
    echo "  --kb | -keybindings         gets installed program ( terminal | browser )"
    echo "  --csp                       checkscreen taking a parameter"
    echo "  --tl                        tiling instans that are not working correctly"
    echo "  --ssha                      start the ssh agent"
    echo "  --sshadd                    add private key to ssh agent"
    echo ""
}

case "$1" in
    "--gm" | "-getMargin")
        getMargin "$2"
        exit;;
    "--r" | "-run")
        run "$2"
        exit;;
    "--rp" | "-runningProcess")
        runningProcess "$2"
        exit;;
    "--cs" | "-checkScreen")
        checkScreen
        exit;;
    "--csp")
        checkScreen "$2"
        exit;;
    "--tl")
        tilingLeft "$2" "$3"
        exit;;
    "--ssha")
        startSSHAgent
        exit;;
    "--sshadd")
        addSSHKey
        exit;;
    "--kb"|"-keybindings")
        keybindings "$2"
        exit;;
    * | "--h" | "-help")
        default
        exit;;
esac

exit;
