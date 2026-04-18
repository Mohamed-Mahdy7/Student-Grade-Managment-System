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
    if [[ -n "$name" && ! $name =~ ^[[:space:]]+$ ]]
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

        touch "$STUDENT_PATH"/${student_id}.stu
        echo "ID: '$student_id'" >> "$STUDENT_PATH"/${student_id}.stu
        echo "Name: '$student_name'" >> "$STUDENT_PATH"/${student_id}.stu
        echo "Email: '$email'" >> "$STUDENT_PATH"/${student_id}.stu
        echo "Year: '$year'" >> "$STUDENT_PATH"/${student_id}.stu
        echo
        echo "Student added successfully!"
        read -p "Press 'Enter' to continue..."
        break
    done
}

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


student_update() {
    clear
    echo ================================
    echo Choose which student to update:
    echo ================================
    for std in "$STUDENT_PATH"/*.stu
    do
        echo "$(basename "$std")"
    done
    if [[ ! "$std" ]]
    then 
        echo "No Student Found!"
    else
        while true
        do
            echo =====================================================
            echo "hint: Type 'back' if you want to exist update menu"
            read -p "Type the ID of the student You want to update: " student_id
            echo =====================================================
            if [[ "$student_id" == 'back' ]]
            then
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break
            elif student_exist $student_id
            then 
                clear
                cat "$STUDENT_PATH"/${student_id}.stu
                echo ==========================================
                echo Select what to update: 
                echo ==========================================
                select opt in Name Email Year Back
                do
                    case $REPLY in
                    [Nn][Aa][Mm][Ee]|1)
                        while true
                        do
                            read -p "write the new name: " new_name
                            clear
                            if validate_name "$new_name"
                            then
                                sed -i "s/^Name: .*/Name: '$new_name'/" \
                                    ""$STUDENT_PATH"/${student_id}.stu"
                                
                                echo Updated!
                                echo =========================================
                                cat "$STUDENT_PATH"/${student_id}.stu
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo "Type 4 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                    [Ee][Mm][Aa][Ii][Ll]|2)
                        while true
                        do
                            read -p "write the new email: " new_email
                            clear
                            if validate_email "$new_email"
                            then
                                sed -i "s/^Email: .*/Email: '$new_email'/" \
                                    ""$STUDENT_PATH"/${student_id}.stu"
                                
                                echo Updated!
                                echo =========================================
                                cat "$STUDENT_PATH"/${student_id}.stu
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo " Type 4 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                    [Yy][Ee][Aa][Rr]|3)
                        while true
                        do
                            read -p "write the new year: " new_year
                            clear
                            if validate_year "$new_year"
                            then
                                sed -i "s/^Year: .*/Year: '$new_year'/" \
                                    ""$STUDENT_PATH"/${student_id}.stu"
                                
                                echo Updated!
                                echo =========================================
                                cat "$STUDENT_PATH"/${student_id}.stu
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo " Type 4 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                    [Bb][Aa][Cc][Kk]|4)
                        echo "Going back..."
                        read -p "Press 'Enter' to continue..."
                        break
                        ;;
                    esac
                done
            fi
        done
    fi
}  

student_delete() {
    clear
    echo ==================================
    echo Choose which student to delete: 
    echo ==================================
    for std in  "$STUDENT_PATH"/*.stu
    do
        echo "$(basename "$std")"
    done
    while true
    do
        echo ===================================================
        read -p "Type the ID of the student you want to delete: " student_id
        echo ===================================================
        if [[ "$student_id" == "back" ]]
        then
            echo "Going back..."
            break
        elif student_exist $student_id
        then
            read -p "Are you sure You want to delete student: ${student_id}? (y|n): " answer
            if [[ $answer == "y" ]]
            then
                rm "$STUDENT_PATH"/${student_id}.stu
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

student_menu() {
    while true
    do 
        clear
        echo Student Menu
        echo ================================================================
        echo Select the number or the word of the operation you want to do?
        echo ================================================================
        select opt in Add List Search Update Delete Exit
        do 
            case $REPLY in
            [Aa][Dd][Dd]|1)
                student_add
                break
                ;;
            [Ll][Ii][Ss][Tt]|2)
                student_list
                break
                ;;
            [Ss][Ee][Aa][Rr][Cc][Hh]|3)
                student_search
                break
                ;;
            [Uu][Pp][Dd][Aa][Tt][Ee]|4)
                student_update
                break
                ;;
            [Dd][Ee][Ll][Ee][Tt][Ee]|5)
                student_delete
                break
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
        clear
        echo =========================
        echo "Add new Subject"
        echo =========================
        while true
        do
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
        
        touch "$SUBJECT_PATH"/${code}.sub
        echo "Code: '$code'" >> "$SUBJECT_PATH"/${code}.sub
        echo "Name: '$subject_name'" >> "$SUBJECT_PATH"/${code}.sub
        echo "Credits: '$credits'" >> "$SUBJECT_PATH"/${code}.sub
        echo
        echo "Subject added successfully!"
        read -p "Press 'Enter' to continue..."
        break
    done
}

subject_list() {
    clear
    if [[ -d "$SUBJECT_PATH"/ ]]
    then
        if ! find "$SUBJECT_PATH"/ -type f -name "*.sub" | read
        then 
            echo "No Subjects yet!"
        else
            echo ==============
            echo "Subjects: "
            echo ==============
            ls "$SUBJECT_PATH"/*.sub | cut -d'/' -f4
        fi
    else
        echo "Subjects directory not found!"
    fi
    read -p "Press 'Enter' to continue..."
}

subject_update() {
    clear
    echo ================================
    echo Choose which subject to update:
    echo ================================
    for sub in "$SUBJECT_PATH"/*.sub
    do
        echo "$(basename "$sub")"
    done
    if [[ ! "$sub" ]]
    then 
        echo "No Subject Found!"
    else
        while true
        do    
            echo =====================================================
            echo "hint: Type 'back' if you want to exist update menu"
            read -p "Type the Code of the subject You want to update: " code
            echo =====================================================
            if [[ "$code" == 'back' ]]
            then
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break
            elif subject_exist $code
            then 
                clear
                cat "$SUBJECT_PATH"/${code}.sub
                echo ==========================================
                echo Select what to update: 
                echo ==========================================
                select opt in Name Credits Back
                do
                    case $REPLY in
                    [Nn][Aa][Mm][Ee]|1)
                        while true
                        do
                            read -p "write the new name: " new_name
                            clear
                            if validate_name "$new_name"
                            then
                                sed -i "s/^Name: .*/Name: '$new_name'/" \
                                    ""$SUBJECT_PATH"/${code}.sub"
                                
                                echo Updated!
                                echo =========================================
                                cat "$SUBJECT_PATH"/${code}.sub
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo "Type 3 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                    [Cc][Rr][Ee][Dd][Ii][Tt][Ss]|2)
                        while true
                        do
                            read -p "write the new credits: " new_credit
                            clear
                            if validate_credit_hours "$new_credit"
                            then
                                sed -i "s/^Credits: .*/Credits: '$new_credit'/" \
                                    ""$SUBJECT_PATH"/${code}.sub"
                                
                                echo Updated!
                                echo =========================================
                                cat "$SUBJECT_PATH"/${code}.sub
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo "Type 3 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                        [Bb][Aa][Cc][Kk]|3)
                            echo "Going back..."
                            read -p "Press 'Enter' to continue..."
                            break
                        ;;
                    esac
                done
            fi
        done
    fi
}

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
                rm "$SUBJECT_PATH"/${code}.sub
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


subject_menu() {
    while true
    do
        clear
        echo Subject Menu
        echo ================================================================
        echo Select the number or the word of the operation you want to do?
        echo ================================================================
        select opt in Add List Update Delete Exit
        do 
            case $REPLY in
            [Aa][Dd][Dd]|1)
                subject_add
                break
                ;;
            [Ll][Ii][Ss][Tt]|2)
                subject_list
                break
                ;;
            [Uu][Pp][Dd][Aa][Tt][Ee]|3)
                subject_update
                break
                ;;
            [Dd][Ee][Ll][Ee][Tt][Ee]|4)
                subject_delete
                break
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
    done
}







menu() {
    while true
    do
        clear
        echo Main Menu
        echo ==============================================================
        echo Select the number of the operation you want to do?
        echo ==============================================================
        select opt in "Manage Students" "Manage Subjects" "Manage Grades" "Reports & Statistics" "Exit"
        do 
            case $REPLY in
            1)
                student_menu
                break
                ;;
            2)
                subject_menu
                break
                ;;
            3)
                echo Grades
                break
                ;;
            4)
                echo "Reports & Statistics"
                break
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
    done
}

# main Call
while true
do
    clear
    menu
    status=$?

    if [[ $status -eq 0 ]]
    then
        break
    else
        echo "Back to menu..."
    fi
done