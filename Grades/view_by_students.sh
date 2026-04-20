#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

view_grades_by_student(){
    echo ================================
    echo Choose which Student to view:
    echo ================================
    while true
    do
        read -p "Type the ID of the student you want to view: " student_id
        if student_exist $student_id
        then
            break
        fi
    done
    for file in ./sgms_data/grades/*.grd
    do
        sub_code=$(basename "$file" .grd)
        if ! sub_grades_not_empty "$sub_code"
        then
            continue
        fi
        
        line=$(grep "^${student_id}|" "$file")
        if [[ -n "$line" ]]
        then
            std_id=$(echo "$line" | cut -d'|' -f1)
            score=$(echo "$line" | cut -d'|' -f2)
            letter=$(echo "$line" | cut -d'|' -f3)
            
            std_name=$(sed -n '2p' "./sgms_data/students/${std_id}.stu" | cut -d"'" -f2)
            
            sub_code=$(basename "$file" .grd)
            sub_name=$(sed -n '2p' "./sgms_data/subjects/${sub_code}.sub" | cut -d"'" -f2)
            
            echo "$std_id | $std_name | $sub_name | $score | $letter"
        fi
        
    done
}