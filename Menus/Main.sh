#! /usr/bin/bash
. ./Menus/Students.sh
. ./Menus/Subjects.sh
. ./Menus/Grades.sh
. ./Menus/Reports.sh

menu() {
    while true
    do
        # clear
        echo Main Menu
        echo ==============================================================
        echo Select the number of the operation you want to do?
        echo ==============================================================
        select opt in "Manage Students" "Manage Subjects" "Manage Grades" "Reports & Statistics" "Exit"
        do 
            case $REPLY in
            1)
                student_menu
                break
                ;;
            2)
                subject_menu
                break
                ;;
            3)
                grade_menu
                break
                ;;
            4)
                report_menu
                break
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
    done
}
