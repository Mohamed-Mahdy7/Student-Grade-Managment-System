#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

shopt -s extglob
SUBJECT_PATH=./sgms_data/subjects
GRADE_PATH=./sgms_data/grades

subject_add() {
    while true
    do
        clear
        echo =========================
        echo "Add new Subject"
        echo =========================
        while true
        do
            echo "hint: Type 'back' if you want to exist add menu"
            read -p "Enter Subject Code: " code
            if [[ "$code" == 'back' ]]
            then 
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break  2
            elif validate_subject_code "$code"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            echo "hint: Type 'back' if you want to exist add menu"
            read -p "Enter Subject Name: " subject_name
            if [[ "$subject_name" == 'back' ]]
            then 
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break  2
            elif validate_name "$subject_name"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            echo "hint: Type 'back' if you want to exist add menu"
            read -p "Enter Subject Credit Hours: " credits
            if [[ "$credits" == 'back' ]]
            then 
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break  2
            elif validate_credit_hours "$credits"
            then
                break
            fi
        done
        
        touch "$SUBJECT_PATH"/"${code}".sub
        touch "$GRADE_PATH"/"${code}".grd
        echo "Code: '$code'" >> "$SUBJECT_PATH"/"${code}".sub
        echo "Name: '$subject_name'" >> "$SUBJECT_PATH"/"${code}".sub
        echo "Credits: '$credits'" >> "$SUBJECT_PATH"/"${code}".sub
        echo
        echo "Subject added successfully!"
        read -p "Press 'Enter' to continue..."
        break
    done
}