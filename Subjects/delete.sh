#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

shopt -s extglob
SUBJECT_PATH=./sgms_data/subjects
GRADE_PATH=./sgms_data/grades

subject_delete() {
    clear
    echo ==================================
    echo Choose which subject to delete: 
    echo ==================================
    for std in  "$SUBJECT_PATH"/*.sub
    do
        echo "$(basename "$std")"
    done
    while true
    do
        echo ===================================================
        echo "hint: Type 'back' if you want to exist delete menu"
        read -p "Type the Code of the subject you want to delete: " code
        echo ===================================================
        if [[ "$code" == "back" ]]
        then
            echo "Going back..."
            break
        elif subject_exist $code
        then
            read -p "Are you sure You want to delete subject: ${code}? (y|n): " answer
            if [[ $answer == "y" ]]
            then
                rm "$SUBJECT_PATH"/"${code}".sub
                rm "$GRADE_PATH"/"${code}".grd
                echo Deleted!
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
        fi
    done
}
