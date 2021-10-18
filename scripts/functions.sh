#!/bin/bash

# Checks the screen resolution and runs function according to the result
checkScreen(){
    local res=$(xrandr -q | grep "*")
    
    # if [[ $res == *"x1024"* ]]; then
    #     echo "1280x1024"
    # fi
    # if [[ $res == *"x1080"* ]]; then
    #     echo "1920x1080"
    # fi
    # if [[ $res == *"x1440"* ]]; then
    #     echo "2560x1440"
    # fi

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
        conf=/etc/xdg/openbox/rc/xml    
    fi

    local cat=$(cat "$conf" | grep "<$@>" | grep -Eo '[0-9]{1,4}')
    echo "$cat"
}

runningProcess(){
    local process=$(wmctrl -lx | grep "$@" | wc -l)
    echo "$process"
}

run(){
    $@ &
    echo "RUNNING $@"
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

default(){
    echo "DEFAULT"
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
    * | "-h" | "--help")
        default
        exit;;
esac

exit;
