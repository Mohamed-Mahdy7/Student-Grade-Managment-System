#! /usr/bin/bash
. ./Students/add.sh
. ./Students/delete.sh
. ./Students/list.sh
. ./Students/search.sh
. ./Students/update.sh


student_menu() {
    while true
    do 
        clear
        echo Student Menu
        echo ================================================================
        echo Select the number or the word of the operation you want to do?
        echo ================================================================
        select opt in Add List Search Update Delete Exit
        do 
            case $REPLY in
            [Aa][Dd][Dd]|1)
                student_add
                break
                ;;
            [Ll][Ii][Ss][Tt]|2)
                student_list
                break
                ;;
            [Ss][Ee][Aa][Rr][Cc][Hh]|3)
                student_search
                break
                ;;
            [Uu][Pp][Dd][Aa][Tt][Ee]|4)
                student_update
                break
                ;;
            [Dd][Ee][Ll][Ee][Tt][Ee]|5)
                student_delete
                break
                ;;
            [Ee][Xx][Ii][Tt]|6)
                echo "exiting..."
                return 0
                ;;
            *)
                echo Invalid Selection!
                echo Try Again
                continue
                ;;
            esac
        done
    done
}