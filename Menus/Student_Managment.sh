#! /usr/bin/bash

. ./Validation/Validate.sh

student_exist() {

    # local id=$1
    # local found="$BASE_DIR/students/${id}.stu"
        if [[ -f "sgms_data/students/${1}.stu" ]]
            then
                echo "student with id: ${1} exists"
                return 0
        else
            echo "student doesn't exists"
            return 1
        fi
}

student_add() {
    while true
    do
        echo =========================
        echo "Add new student"
        echo =========================
        while true
        do
            read -p "Enter Student ID: " student_id
            if validate_id $student_id
            then 
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter Student Name: " student_name
            if validate_name $student_name
            then
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter Student Email: " email
            if validate_email $email
            then
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter the year: " year
            if validate_year $year
            then 
                break
            fi
        done

        touch ./sgms_data/students/${student_id}.stu
        echo "ID: '$student_id'" >> ./sgms_data/students/${student_id}.stu
        echo "Name: '$student_name'" >> ./sgms_data/students/${student_id}.stu
        echo "Email: '$email'" >> ./sgms_data/students/${student_id}.stu
        echo "Year: '$year'" >> ./sgms_data/students/${student_id}.stu

        echo "Student added successfully!"
        break
    done
}

student_list() {
    if [[ -d ./sgms_data/students/ ]]
    then
        if [[ `ls ./sgms_data/students/` == "" ]]
        then 
            echo "No Students yet!"
        else
            ls ./sgms_data/students/
        fi
    else
        echo "Students directory not found!"
    fi
}

# student_update() {

# }

# student_delete() {

# }

student_menu() {
    echo Student Menu
    echo ================================================================
    echo Select the number or the word of the operation you want to do?
    echo ================================================================
    select opt in Add List Update Delete Exit
    do 
        case $REPLY in
        [Aa][Dd][Dd]|1)
            student_add
            ;;
        [Ll][Ii][Ss][Tt]|2)
            student_list
            ;;
        [Uu][Pp][Dd][Aa][Tt][Ee]|3)
            student_update
            ;;
        [Dd][Ee][Ll][Ee][Tt][Ee]|4)
            student_delete
            ;;
        [Ee][Xx][Ii][Tt]|5)
            echo "exiting..."
            return 0
            ;;
        *)
            echo Invalid Selection!
            echo Try Again
            continue
            ;;
        esac
    done
}