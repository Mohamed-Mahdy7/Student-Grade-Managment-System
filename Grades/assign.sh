#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

assign_grade(){
    echo ================================
    echo Choose which student to assign:
    echo ================================
    for std in $(ls ./sgms_data/students/)
    do
        echo $std
    done
    echo =====================================================
    while true
    do
        read -p "Type the ID of the student you want to assign: " student_id
        if student_exist $student_id
        then
            break
        fi
    done
    echo =====================================================
    while true
    do
        read -p "Type the Code of the subject you want to assign the grade to: " subject_id
        if subject_exist $subject_id
        then
            break
        fi
    done    
    echo =====================================================    
    sub_grades_exists $subject_id
    while true
    do
        read -p "Type the score you want to assign to the student : " score
        if validate_score $score
        then
            break
        fi
    done
    echo =====================================================    
    L=$(score_to_letter $score)
    if grep -q "^${student_id}|" "./sgms_data/grades/${subject_id}.grd";
    then
        echo "This student is already assigned"
    else
        echo "$student_id|$score|$L" >> "./sgms_data/grades/${subject_id}.grd"
        echo "Grade Successfully Assigned"
    fi
}