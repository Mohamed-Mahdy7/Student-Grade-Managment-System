#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

top_students(){
    while true
    do
        read -p "Type how many top students to find: " N
        if [[ "$N" =~ ^[0-9]{1,10}$ ]]
        then
            break
        else
            echo "Error: Enter a number"
        fi
    done  
    echo ================================
    echo ========= Top Students =========
    echo ================================
    echo " ID | Name | GPA "

    for file in ./sgms_data/students/*.stu
    do
        std_id=$(basename "$file" .stu)
        std_name=$(sed -n '2p' "$file" | cut -d"'" -f2)
        gpa=$(calculate_gpa "$std_id")
        echo "$gpa $std_id $std_name"

    done | sort -rn | head -n "$N"
}
