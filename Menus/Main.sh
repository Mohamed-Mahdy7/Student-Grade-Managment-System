#! /usr/bin/bash

. ./Student_Management.sh
. ./Subject_Management.sh


menu() {
    echo Main Menu
    echo ===================================================
    echo Select the number of the operation you want to do?
    echo ===================================================
    select opt in "Manage Students" "Manage Subjects" "Manage Grades" "Reports & Statistics" "Exit"
    do 
        case $REPLY in
        1)
            echo Students
            ;;
        2)
            echo Subjects
            ;;
        3)
            echo Grades
            ;;
        4)
            echo "Reports & Statistics"
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