#! /usr/bin/bash

grade_menu(){
    select opt in Transcript Statistics Top Failing Matrix
    do
        case $REPLY in
            [Tt][Rr][Aa][Nn][Ss][Cc][Rr][Ii][Pp][Tt]|1)
            ;;
            [Ss][Tt][Aa][Tt][Ii][Ss][Tt][Ii][Cc][Ss]|2)
            ;;
            [Tt][Oo][Pp]|3)
            ;;
            [Ff][Aa][Ii][Ll][Ii][Nn][Gg]|4)
            ;;
            [Mm][Aa][Tt][Rr][Ii][Xx]|5)
            ;;
}