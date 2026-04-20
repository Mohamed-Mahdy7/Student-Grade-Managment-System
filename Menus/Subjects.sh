#! /usr/bin/bash
. ./Subjects/add.sh
. ./Subjects/delete.sh
. ./Subjects/list.sh
. ./Subjects/update.sh

subject_menu() {
    while true
    do
        clear
        echo Subject Menu
        echo ================================================================
        echo Select the number or the word of the operation you want to do?
        echo ================================================================
        select opt in Add List Update Delete Exit
        do 
            case $REPLY in
            [Aa][Dd][Dd]|1)
                subject_add
                break
                ;;
            [Ll][Ii][Ss][Tt]|2)
                subject_list
                break
                ;;
            [Uu][Pp][Dd][Aa][Tt][Ee]|3)
                subject_update
                break
                ;;
            [Dd][Ee][Ll][Ee][Tt][Ee]|4)
                subject_delete
                break
                ;;
            [Ee][Xx][Ii][Tt]|5)
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