#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

shopt -s extglob
STUDENT_PATH=./sgms_data/students

student_list() {
    clear
    if [[ -d "$STUDENT_PATH"/ ]]
    then
        if ! find "$STUDENT_PATH" -type f -name "*.stu" | read
        then 
            echo "No Students yet!"
        else
            echo ==============
            echo "Students: "
            echo ==============
            ls "$STUDENT_PATH"/*.stu | cut -d'/' -f4
        fi
    else
        echo "Students directory not found!"
    fi
    read -p "Press 'Enter' to continue..."
}