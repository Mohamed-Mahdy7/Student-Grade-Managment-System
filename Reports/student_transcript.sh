#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

student_transcript(){
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
    echo ================================
    echo ====== Student Transcript ======
    echo ================================
    for file in ./sgms_data/grades/*.grd
    do
        line=$(grep "^${student_id}|" "$file")
        if [[ -n "$line" ]]
        then
            std_id=$(echo "$line" | cut -d'|' -f1)
            score=$(echo "$line" | cut -d'|' -f2)
            letter=$(echo "$line" | cut -d'|' -f3)
            
            sub_code=$(basename "$file" .grd)
            sub_name=$(sed -n '2p' "./sgms_data/subjects/${sub_code}.sub" | cut -d"'" -f2)

            GPA=$(score_to_gpa "$score")

            echo "$sub_code | $sub_name | $score | $letter | $GPA"
        fi
    done
    CGPA=$(calculate_weighted_gpa "$std_id")
    echo ================================
    echo "Cumulative GPA:" "$CGPA"

}
