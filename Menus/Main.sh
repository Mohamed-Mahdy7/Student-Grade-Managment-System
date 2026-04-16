#! /usr/bin/bash

. ./Menus/Student_Managment.sh
. ./Menus/Subject_Managment.sh


menu() {
    echo Main Menu
    echo ==============================================================
    echo Select the number of the operation you want to do?
    echo ==============================================================
    select opt in "Manage Students" "Manage Subjects" "Manage Grades" "Reports & Statistics" "Exit"
    do 
        case $REPLY in
        1)
            student_menu
            ;;
        2)
            subject_menu
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
            continue
            ;;
        esac
    done
}