#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

update_grade(){
    echo =====================================
    echo Choose which student grade to update:
    echo =====================================
    for std in $(ls ./sgms_data/students/)
    do
        echo $std
    done
    echo =====================================================
    while true
    do
        read -p "Type the ID of the student you want to update: " student_id
        if student_exist $student_id
        then
            break
        fi
    done
    echo =====================================================
    while true
    do
        read -p "Type the Code of the subject you want to update the grade of: " subject_id
        if subject_exist $subject_id
        then
            break
        fi
    done    
    echo =====================================================    
    while true
    do
        read -p "Type the score you want to update : " score
        if validate_score $score
        then
            break
        fi
    done
    echo =====================================================    
    L=$(score_to_letter $score)
    sed -i "/^${student_id}|/d" "./sgms_data/grades/${subject_id}.grd"
    echo "$student_id|$score|$L" >> "./sgms_data/grades/${subject_id}.grd"
    echo "Grade Successfully Updated"
}