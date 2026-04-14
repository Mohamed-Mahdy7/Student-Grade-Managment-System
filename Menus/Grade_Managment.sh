#! /usr/bin/bash

grade_menu(){
    select opt in Assign Update Delete ViewSubject ViewStudent
    do
        case $REPLY in
            [Aa][Ss][Ss]Ii][Gg][Nn]|1)
            ;;
            [Uu][Pp][Dd][Aa][Tt][Ee]|2)
            ;;
            [Dd][Ee][Ll][Ee][Tt][Ee]|3)
            ;;
            [Vv][Ii][Ee][Ww][Ss][Uu][Bb][Jj][Ee][Cc][Tt]|4)
            ;;
            [Vv][Ii][Ee][Ww][Ss][Tt][Uu][Dd][Ee][Nn][Tt]|5)
            ;;
}