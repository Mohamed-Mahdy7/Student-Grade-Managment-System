#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

view_grades_by_subject(){
    echo ================================
    echo Choose which Subject to view:
    echo ================================
    while true
    do
        read -p "Type the Code of the subject you want to view the grades of: " subject_id
        if subject_exist $subject_id
        then
            break
        fi
    done
    for file in ./sgms_data/grades/${subject_id}.grd
    do
        for std_id in $(cut -d'|' -f1 "$file")
        do
            line=$(grep "^${std_id}|" "$file")
            score=$(echo "$line" | cut -d'|' -f2)
            letter=$(echo "$line" | cut -d'|' -f3)

            std_name=$(sed -n '2p' "./sgms_data/students/${std_id}.stu"  | cut -d"'" -f2)

            echo "$std_id | $std_name | $score | $letter"
        done
    done
}