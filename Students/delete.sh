#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

shopt -s extglob
STUDENT_PATH=./sgms_data/students
GRADE_PATH=./sgms_data/grades

student_delete() {
    clear
    echo ==================================
    echo Choose which student to delete: 
    echo ==================================
    for std in  "$STUDENT_PATH"/*.stu
    do
        echo "$(basename "$std")"
    done
    while true
    do
        echo ===================================================
        echo "hint: Type 'back' if you want to exist delete menu"
        read -p "Type the ID of the student you want to delete: " student_id
        echo ===================================================
        if [[ "$student_id" == "back" ]]
        then
            echo "Going back..."
            break
        elif student_exist $student_id
        then
            read -p "Are you sure You want to delete student: ${student_id}? (y|n): " answer
            if [[ $answer == "y" ]]
            then
                found=0

                for grd in "$GRADE_PATH"/*.grd
                do
                    if [[ -f "$grd" ]]
                    then
                        if grep "^$student_id|" "$grd"
                        then
                            found=1
                            break
                        fi
                    fi
                done
                if [[ $found == 1 ]]
                then
                    echo "This Student has grades," 
                    echo "You must delete his/her grade first!"
                else
                    rm "$STUDENT_PATH"/"${student_id}".stu
                    echo Deleted!
                    read -p "Press 'Enter' to continue..."
                    break
                fi
                
            elif [[ $answer == "n" ]]
            then
                read -p "Press 'Enter' to continue..."
                break
            else
                echo "Invalid input!"
                continue
            fi
        fi
    done
}