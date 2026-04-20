#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

delete_grade(){
    echo ================================
    echo Choose which student to delete:
    echo ================================
    for std in $(ls ./sgms_data/students/)
    do
        echo $std
    done
    echo =====================================================
    while true
    do
        read -p "Type the ID of the student you want to delete: " student_id
        if student_exist $student_id
        then
            break
        fi
    done
    echo =====================================================
    while true
    do
        read -p "Type the Code of the subject you want to delete the grade of: " subject_id
        if subject_exist $subject_id
        then
            if sub_grades_exists $subject_id && $sub_grades_not_empty $subject_id
            then
                break
            fi
        fi
    done    
    echo =====================================================  
    read -p "Are you sure You want to delete subject: ${subject_id}? (y|n): " answer
    if [[ $answer == "y" ]]
    then
        sed -i "/^${student_id}|/d" "./sgms_data/grades/${subject_id}.grd"
        echo "Grade Deleted Successfully" 
        read -p "Press 'Enter' to continue..."
        break
    elif [[ $answer == "n" ]]
    then
        read -p "Press 'Enter' to continue..."
        break
    else
        echo "Invalid input!"
        continue
    fi
    
}
