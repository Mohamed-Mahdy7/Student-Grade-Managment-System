#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

shopt -s extglob
STUDENT_PATH=./sgms_data/students

student_search() {
    clear
    echo =======================================
    echo Search Student by Name
    echo =======================================
    echo "hint: Type 'back' if you want to exist search menu"
    read -p "Enter Student Name to search with: " student_name
    if [[ "$student_name" == 'back' ]]
    then
        echo "Going back..."
        break
    elif ! find "$STUDENT_PATH" -type f -name "*.stu" | read
    then 
        echo "No Students yet!"
    else
        student=$(grep -H "Name:.*$student_name" "$STUDENT_PATH"/*.stu)
        if [[ -z "$student" ]]
        then
            echo "Student not found!"
        else
            declare -a path=($(echo "$student" | cut -d: -f1 | sort -u))
            for m in "${path[@]}"
            do
                matched+=("$(basename "$m")")
            done
            if (( ${#matched[@]} > 1 )) 
            then
                echo
                echo "Multiple students found!"
                echo =======================================================
                echo "Select the number of the student you want to display: "
                echo =======================================================
                select f in "${matched[@]}" "Back"
                do
                    if [[ "$f" == 'Back' ]]
                    then
                        echo "Going back..."
                        break
                    elif [[ -n "$f" ]]
                    then
                        echo
                        cat "$STUDENT_PATH"/"$f"
                        break
                    else
                        echo "Wrong number"
                    fi
                done
            else
                echo
                cat "${path[0]}"
            fi
            unset matched
        fi
    fi
    read -p "Press 'Enter' to continue..."
}