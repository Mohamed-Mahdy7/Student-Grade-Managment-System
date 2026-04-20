#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh  #Validate
shopt -s extglob
STUDENT_PATH=./sgms_data/students

student_add() {
    while true
    do
        clear
        echo =========================
        echo "Add new student"
        echo =========================
        while true
        do
            echo "hint: Type 'back' if you want to exist add menu"
            read -p "Enter Student ID: " student_id
            if [[ "$student_id" == 'back' ]]
            then 
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break  2
            elif validate_id "$student_id"
            then 
                break
            fi
        done
        echo =========================
        while true
        do
            echo "hint: Type 'back' if you want to exist add menu"
            read -p "Enter Student Name: " student_name
            if [[ "$student_name" == 'back' ]]
            then 
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break 2
            elif validate_name "$student_name"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            echo "hint: Type 'back' if you want to exist add menu"
            read -p "Enter Student Email: " email
            if [[ "$email" == 'back' ]]
            then 
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break 2
            elif validate_email "$email"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            echo "hint: Type 'back' if you want to exist add menu"
            read -p "Enter the year: " year
            if [[ "$year" == 'back' ]]
            then 
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break 2
            elif validate_year "$year"
            then 
                break
            fi
        done

        touch "$STUDENT_PATH"/"${student_id}".stu
        echo "ID: '$student_id'" >> "$STUDENT_PATH"/"${student_id}".stu
        echo "Name: '$student_name'" >> "$STUDENT_PATH"/"${student_id}".stu
        echo "Email: '$email'" >> "$STUDENT_PATH"/"${student_id}".stu
        echo "Year: '$year'" >> "$STUDENT_PATH"/"${student_id}".stu
        echo
        echo "Student added successfully!"
        read -p "Press 'Enter' to continue..."
        break
    done
}