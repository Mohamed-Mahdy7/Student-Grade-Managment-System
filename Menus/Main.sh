#! /usr/bin/bash

menu() {
    echo Main Menu
    echo ===================================================
    echo Select the number of the operation you want to do?
    echo ===================================================
    select opt in "Manage Students" "Manage Subjects" "Manage Grades" "Reports & Statistics" "Exit"
    do 
        case $REPLY in
        1)
            
            ;;
        2)
            
            ;;
        3)
            
            ;;
        4)
            
            ;;
        5)
            echo "exiting..."
            return 0
            ;;
        *)
            echo Invalid Selection!
            echo Try Again
        esac
    done
}