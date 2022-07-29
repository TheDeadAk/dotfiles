#!/bin/sh
list=$(ls /usr/bin/ | grep -m 10 -i "$1")
buf=""
for i in $list ; do
    buf="$buf (button :class \"item\" :onclick \"$i & eww close searchapps \" \"$i\")"
done
echo "(box :orientation \"v\" :spacing 5 :class \"apps\" :halign \"center\" :valign \"center\" $buf)" > ~/.config/eww/scripts/search_items.txt
