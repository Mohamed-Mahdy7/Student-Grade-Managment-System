#! /usr/bin/bash

shopt -s extglob

BASE_DIR=$(dirname $0)/sgms_data
mkdir -p $BASE_DIR/students $BASE_DIR/subjects $BASE_DIR/grades

STUDENT_PATH=$BASE_DIR/students
SUBJECT_PATH=$BASE_DIR/subjects
GRADE_PATH=$BASE_DIR/grades

validate_id(){
    local id="$1"
    if [[ "$id" =~ ^[0-9]{1,10}$ ]]
    then
        if [[ -f ""$STUDENT_PATH"/$student_id.stu" ]]
        then 
            echo "Student with ID: ${student_id} already exists!"
            return 1
        else
            echo "Valid Student ID"
            return 0
        fi
    else
        echo "Error: Student ID must be numeric from 0-9 and less than 10 digits"
        return 1
    fi
}

validate_name(){
    local name="$1"
    if [[ -n "$name" && ! $student_name =~ ^[[:space:]]+$ ]]
    then
        echo "Valid Student Name"
        return 0
    else
        echo "Error: Student Name shouldn't be empty or only spaces,"
        echo "Only printable characters allowed"
        return 1
    fi
}

validate_email(){
    local email="$1"
    if [[ "$email" =~ ^[^@]+@[^@]+\.[^@]+$  ]]
    then
        echo "Valid Email"
        return 0
    else
        echo "Error: Email Must contain @ and domain dot,like : user@domain.ext"
        return 1
    fi
}

validate_year(){
    local year="$1"
    if [[ "$year" =~ ^[0-6]$ ]]
    then
        echo "Valid year"
        return 0
    else
        echo "Error: Year must be a number from 1-6"
        return 1
    fi
}

validate_subject_code(){
    local code="$1"
    if [[ "$code" =~ ^[A-Z]{2,5}[0-9]{2,4}$ ]]
    then
        if [[ -f ""$SUBJECT_PATH"/$code.sub" ]]
        then 
            echo "Subject with Code: ${code} already exists!"
            return 1
        else
            echo "Valid Subject Code"
            return 0
        fi
    else
        echo "Error: Code must start with Capital (2-5) letters + (2-4) numbers "
        return 1
    fi
}

validate_credit_hours(){
    local hours="$1"
    if [[ "$hours" =~ ^[0-6]$ ]]
    then
        echo "Valid Credits"
        return 0
    else
        echo ""Error: Credits must be a number from 1-6""
        return 1
    fi
}

validate_score() {
    local score="$1"
    if [[ "$score" =~ ^[0-9]+(\.[0-9]+)?$ ]] && \
        awk -v gs="$grade_score" ' BEGIN {
            if (gs >= 0.0 && gs <= 100.0) {
                exit 0;
            } 
            else {
                exit 1;
            }
        }'
    then
        echo "Valid Score"
        return 0
    else
        echo "Error: Score must be float number (0.0 - 100.0)"
        return 1
    fi
}

student_exist() {
    local id="$1"
    if [[ -f ""$STUDENT_PATH"/${id}.stu" ]]
        then
            echo "student with id: ${id} exists"
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
            if validate_id "$student_id"
            then 
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter Student Name: " student_name
            if validate_name "$student_name"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter Student Email: " email
            if validate_email "$email"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter the year: " year
            if validate_year "$year"
            then 
                break
            fi
        done

        touch "$STUDENT_PATH"/${student_id}.stu
        echo "ID: '$student_id'" >> "$STUDENT_PATH"/${student_id}.stu
        echo "Name: '$student_name'" >> "$STUDENT_PATH"/${student_id}.stu
        echo "Email: '$email'" >> "$STUDENT_PATH"/${student_id}.stu
        echo "Year: '$year'" >> "$STUDENT_PATH"/${student_id}.stu

        echo "Student added successfully!"
        break
    done
}

student_list() {
    if [[ -d "$STUDENT_PATH"/ ]]
    then
        if ! find "$STUDENT_PATH" -type f -name "*.stu" | read
        then 
            echo "No Students yet!"
        else
            ls "$STUDENT_PATH"/
        fi
    else
        echo "Students directory not found!"
    fi
}

student_search() {
    echo =======================================
    echo Search Student by Name
    echo =======================================
    read -p "Enter Student Name to search with: " student_name
    if ! find "$STUDENT_PATH" -type f -name "*.stu" | read
    then 
        echo "No Students yet!"
    else
        student=$(grep -H "Name:.*$student_name" "$STUDENT_PATH"/*.stu)
        echo "student ${student}"
        if [[ -z "$student" ]]
        then
            echo "Student not found!"
        else
            declare -a path=($(echo "$student" | cut -d: -f1 | sort -u))
            echo "path ${path}"
            for m in "${path[@]}"
            do
                matched+=("$(basename "$m")")
                echo "matched ${matched}"
            done
            if (( ${#matched[@]} > 1 )) 
            then
                echo
                echo "Multiple students found!"
                echo =======================================================
                echo "Select the number of the student you want to display: "
                echo =======================================================
                select f in "${matched[@]}"
                do
                    echo
                    cat ""$STUDENT_PATH"/$f"
                    break
                done
            else
                echo
                cat "${path[0]}"
            fi
            unset matched
        fi
    fi
}


student_update() {
    echo ================================
    echo Choose which student to update:
    echo ================================
    for std in $(ls "$STUDENT_PATH"/)
    do
        echo $std
    done
    if [[ ! "$std" ]]
    then 
        echo "No Student Found!"
    else
        while true
        do
            echo =====================================================
            read -p "Type the ID of the student You want to update: " student_id
            echo =====================================================
            if student_exist $student_id
            then 
                cat "$STUDENT_PATH"/${student_id}.stu
                echo ==========================================
                echo Select what to update: 
                echo ==========================================
                select opt in Name Email Year
                do
                    case $REPLY in
                    [Nn][Aa][Mm][Ee]|1)
                        while true
                        do
                            read -p "write the new name: " new_name
                            if validate_name "$new_name"
                            then
                                sed -i "s/^Name: .*/Name: '$new_name'/" \
                                    ""$STUDENT_PATH"/${student_id}.stu"
                                
                                echo Updated!
                                echo =========================================
                                cat "$STUDENT_PATH"/${student_id}.stu
                                echo =========================================
                                break
                            fi
                        done
                        ;;
                    [Ee][Mm][Aa][Ii][Ll]|2)
                        while true
                        do
                            read -p "write the new email: " new_email
                            if validate_email "$new_email"
                            then
                                sed -i "s/^Email: .*/Email: '$new_email'/" \
                                    ""$STUDENT_PATH"/${student_id}.stu"
                                
                                echo Updated!
                                echo =========================================
                                cat "$STUDENT_PATH"/${student_id}.stu
                                echo =========================================
                                break
                            fi
                        done
                        ;;
                    [Yy][Ee][Aa][Rr]|3)
                        while true
                        do
                            read -p "write the new year: " new_year
                            if validate_year "$new_year"
                            then
                                sed -i "s/^Year: .*/Year: '$new_year'/" \
                                    ""$STUDENT_PATH"/${student_id}.stu"
                                
                                echo Updated!
                                echo =========================================
                                cat "$STUDENT_PATH"/${student_id}.stu
                                echo =========================================
                                break
                            fi
                        done
                        ;;
                    esac
                done
            fi
        done
    fi
}  

student_delete() {
    echo ==================================
    echo Choose which student to delete: 
    echo ==================================
    for std in $(ls "$STUDENT_PATH"/)
    do
        echo $std
    done
    echo ===================================================
    while true
    do
        read -p "Type the ID of the student you want to delete: " student_id
        echo ===================================================
        if student_exist $student_id
        then
            read -p "Are you sure You want to delete student: ${student_id}? (y|n): " answer
            if [[ $answer == "y" ]]
            then
                rm "$STUDENT_PATH"/${student_id}.stu
                echo Deleted!
                break
            elif [[ $answer == "n" ]]
            then
                break
            else
                continue
            fi
        fi
    done
}

student_menu() {
    echo Student Menu
    echo ================================================================
    echo Select the number or the word of the operation you want to do?
    echo ================================================================
    select opt in Add List Search Update Delete Exit
    do 
        case $REPLY in
        [Aa][Dd][Dd]|1)
            student_add
            ;;
        [Ll][Ii][Ss][Tt]|2)
            student_list
            ;;
        [Ss][Ee][Aa][Rr][Cc][Hh]|3)
            student_search
            ;;
        [Uu][Pp][Dd][Aa][Tt][Ee]|4)
            student_update
            ;;
        [Dd][Ee][Ll][Ee][Tt][Ee]|5)
            student_delete
            ;;
        [Ee][Xx][Ii][Tt]|6)
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

subject_exist() {
    local id="$1"
    if [[ -f ""$SUBJECT_PATH"/${id}.sub" ]]
        then
            echo "subjects with code: ${id} exists"
            return 0
    else
        echo "subjects doesn't exists"
        return 1
    fi
}

subject_add() {
    while true
    do
        echo =========================
        echo "Add new Subject"
        echo =========================
        while true
        do
            read -p "Enter Subject Code: " code
            if validate_subject_code "$code"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter Subject Name: " subject_name
            if validate_name "$subject_name"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter Subject Credit Hours: " credits
            if validate_credit_hours "$credits"
            then
                break
            fi
        done
        
        touch "$SUBJECT_PATH"/${code}.sub
        echo "Code: '$code'" >> "$SUBJECT_PATH"/${code}.sub
        echo "Name: '$subject_name'" >> "$SUBJECT_PATH"/${code}.sub
        echo "Credits: '$credits'" >> "$SUBJECT_PATH"/${code}.sub

        echo "Subject added successfully!"
        break
    done
}

subject_list() {
    if [[ -d "$SUBJECT_PATH"/ ]]
    then
        if [[ `ls "$SUBJECT_PATH"/` == "" ]]
        then 
            echo "No Subjects yet!"
        else
            ls "$SUBJECT_PATH"/
        fi
    else
        echo "Subjects directory not found!"
    fi
}

subject_update() {
    echo ================================
    echo Choose which subject to update:
    echo ================================
    for sub in $(ls "$SUBJECT_PATH"/)
    do
        echo $sub
    done
    if [[ ! "$sub" ]]
    then 
        echo "No Subject Found!"
    else
        while true
        do    
            echo =====================================================
            read -p "Type the Code of the subject You want to update: " code
            echo =====================================================
            if subject_exist $code
            then 
                cat "$SUBJECT_PATH"/${code}.sub
                echo ==========================================
                echo Select what to update: 
                echo ==========================================
                select opt in Name Credits
                do
                    case $REPLY in
                    [Nn][Aa][Mm][Ee]|1)
                        while true
                        do
                            read -p "write the new name: " new_name
                            if validate_name "$new_name"
                            then
                                sed -i "s/^Name: .*/Name: '$new_name'/" \
                                    ""$SUBJECT_PATH"/${code}.sub"
                                
                                echo Updated!
                                echo =========================================
                                cat "$SUBJECT_PATH"/${code}.sub
                                echo =========================================
                                break
                            fi
                        done
                        ;;
                    [Cc][Rr][Ee][Dd][Ii][Tt][Ss]|2)
                        while true
                        do
                            read -p "write the new credits: " new_credit
                            if validate_credit_hours "$new_credit"
                            then
                                sed -i "s/^Credits: .*/Credits: '$new_credit'/" \
                                    ""$SUBJECT_PATH"/${code}.sub"
                                
                                echo Updated!
                                echo =========================================
                                cat "$SUBJECT_PATH"/${code}.sub
                                echo =========================================
                                break
                            fi
                        done
                        ;;
                    esac
                done
            fi
        done
    fi
}

subject_delete() {
    echo ==================================
    echo Choose which subject to delete: 
    echo ==================================
    for std in $(ls "$SUBJECT_PATH"/)
    do
        echo $std
    done
    echo ===================================================
    while true
    do
        read -p "Type the Code of the subject you want to delete: " code
        echo ===================================================
        if subject_exist $code
        then
            read -p "Are you sure You want to delete subject: ${code}? (y|n): " answer
            if [[ $answer == "y" ]]
            then
                rm "$SUBJECT_PATH"/${code}.sub
                echo Deleted!
                break
            elif [[ $answer == "n" ]]
            then
                break
            else
                continue
            fi
        fi
    done
}


subject_menu() {
    echo Subject Menu
    echo ================================================================
    echo Select the number or the word of the operation you want to do?
    echo ================================================================
    select opt in Add List Update Delete Exit
    do 
        case $REPLY in
        [Aa][Dd][Dd]|1)
            subject_add
            ;;
        [Ll][Ii][Ss][Tt]|2)
            subject_list
            ;;
        [Uu][Pp][Dd][Aa][Tt][Ee]|3)
            subject_update
            ;;
        [Dd][Ee][Ll][Ee][Tt][Ee]|4)
            subject_delete
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







menu() {
    echo Main Menu
    echo ==============================================================
    echo Select the number of the operation you want to do?
    echo ==============================================================
    select opt in "Manage Students" "Manage Subjects" "Manage Grades" "Reports & Statistics" "Exit"
    do 
        case $REPLY in
        1)
            student_menu
            ;;
        2)
            subject_menu
            ;;
        3)
            echo Grades
            ;;
        4)
            echo "Reports & Statistics"
            ;;
        5)
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

# main Call
while true
do
    menu
    status=$?

    if [[ $status -eq 0 ]]
    then
        break
    else
        echo "Back to menu..."
    fi
done