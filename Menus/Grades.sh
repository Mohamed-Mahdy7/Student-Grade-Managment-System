#! /usr/bin/bash
. ./Grades/assign.sh
. ./Grades/delete.sh
. ./Grades/update.sh
. ./Grades/view_by_students.sh
. ./Grades/view_by_subjects.sh


grade_menu(){
    select opt in "Assign Grade to Student" "Update Grade" "Delete Grade" "View Grades by Subject" "View Grades by Student" "Exit"
    do
        case $REPLY in
            1)
            assign_grade
            ;;
            2)
            update_grade
            ;;
            3)
            delete_grade
            ;;
            4)
            view_grades_by_subject
            ;;
            5)
            view_grades_by_student
            ;;
            6)
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