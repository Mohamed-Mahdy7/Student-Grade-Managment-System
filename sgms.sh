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
    if [[ -n "$name" && ! $name =~ ^[A-Za-z][A-Za-z[:space:]]+$ ]]
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
    if [[ "$email" =~ ^[A-Za-z][^@]+@[^@]+\.[^@]+$  ]]
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
    score="$1"
    if [[ "$score" =~ ^[0-9]+\.[0-9]+$ ]] && \
        awk -v gs="$score" ' BEGIN {
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
        echo "hint: Type 'back' if you want to exist delete menu"
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
                found=0

                for grd in "$GRADE_PATH"/*.grd
                do
                    if [[ -f "$grd" ]]
                    then
                        if grep "^$student_id|" "$grd"
                        then
                            found=1
                            break
                        fi
                    fi
                done
                if [[ $found == 1 ]]
                then
                    echo "This Student has grades," 
                    echo "You must delete his/her grade first!"
                else
                    rm "$STUDENT_PATH"/${student_id}.stu
                    echo Deleted!
                    read -p "Press 'Enter' to continue..."
                    break
                fi
                
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
        
        touch "$SUBJECT_PATH"/${code}.sub
        touch "$GRADE_PATH"/${code}.grd
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

# Grade Helpers

sub_grades_exists(){
    local id="$1"
    if [[ -f "$GRADE_PATH/${id}.grd" ]]
        then
            echo "Subject grades file with code: ${id} exists"
            return 0
    else
        echo "Error: Subject grades file with code: ${id} does not exist"
        return 1
    fi
}

score_to_letter(){
    
    echo "$1" | awk '
    {
        score = $1
        grade=""

        if(score >= 90){
            grade = "A+"
        }else if(score >= 85){
            grade = "A"
        }else if(score >= 80){
            grade = "A-"
        }else if(score >= 75){
            grade = "B+"
        }else if(score >= 70){
            grade = "B"
        }else if(score >= 65){
            grade = "B-"
        }else if(score >= 60){
            grade = "C+"
        }else if(score >= 55){
            grade = "C"
        }else if(score >= 50){
            grade = "C-"
        }else if(score >= 45){
            grade = "D"
        }else{
            grade = "F"
        }
        print grade
    }
    '
}

score_to_gpa(){
    
    echo "$1" | awk '
    {
        score = $1
        GPA = 0.0

        if(score >= 85){
            GPA = 4.0
        }else if(score >= 80){
            GPA = 3.7
        }else if(score >= 75){
            GPA = 3.3
        }else if(score >= 70){
            GPA = 3.0
        }else if(score >= 65){
            GPA = 2.7
        }else if(score >= 60){
            GPA = 2.3
        }else if(score >= 55){
            GPA = 2.0
        }else if(score >= 50){
            GPA = 1.7
        }else if(score >= 45){
            GPA = 1.0
        }else{
            GPA = 0.0
        }
        printf "%.1f\n", GPA
    }
    '
}


calculate_gpa(){
    local std_id="$1"
    local total=0
    local count=0
    if student_exist "$std_id"; then
        for file in ./sgms_data/grades/*.grd
        do
            line=$(grep "^${std_id}|" "$file")
            if [[ -n "$line" ]]
            then
                score=$(echo "$line" | cut -d'|' -f2)
                gpa=$(score_to_gpa "$score")
                total=$(echo "$total $gpa" |
                awk '
                {
                    printf "%.2f\n", $1+$2
                }
                ')
                count=$((count+1))
            fi            
        done
        echo "$total $count" |
            awk '
            {
                printf "%.2f\n", $1/$2
            }
           '
    fi
}


calculate_weighted_gpa(){
    local std_id="$1"
    local total=0
    local count=0
    if student_exist "$std_id"; then
        for file in ./sgms_data/grades/*.grd
        do
            grade_line=$(grep "^${std_id}|" "$file")
            if [[ -n "$grade_line" ]]
            then
                score=$(echo "$grade_line" | cut -d'|' -f2)
                gpa=$(score_to_gpa "$score")
                sub_code=$(basename "$file" .grd)
                credits=$(sed -n '3p' "./sgms_data/subjects/${sub_code}.sub")
                total=$(echo "$total $gpa $credits" |
                awk '
                {
                    print $1+($2*$3)
                }
                ')
                count=$(echo "$count $credits" |
                awk '
                {
                    printf "%.2f\n", $1+$2
                }
                ')
            fi
        done
        echo "$total $count" |
            awk '
            {
                printf "%.2f\n", $1/$2
            }
           '
    fi
}

# Grade CRUD

assign_grade(){
    echo ================================
    echo Choose which student to assign:
    echo ================================
    for std in $(ls ./sgms_data/students/)
    do
        echo $std
    done
    echo =====================================================
    while true
    do
        read -p "Type the ID of the student you want to assign: " student_id
        if student_exist $student_id
        then
            break
        fi
    done
    echo =====================================================
    while true
    do
        read -p "Type the ID of the subject you want to assign the grade to: " subject_id
        if subject_exist $subject_id
        then
            break
        fi
    done    
    echo =====================================================    
    sub_grades_exists $subject_id
    while true
    do
        read -p "Type the score you want to assign to the student : " score
        if validate_score $score
        then
            break
        fi
    done
    echo =====================================================    
    L=$(score_to_letter $score)
    if grep -q "^${student_id}|" "./sgms_data/grades/${subject_id}.grd";
    then
        echo "This student is already assigned"
    else
        echo "$student_id|$score|$L" >> "./sgms_data/grades/${subject_id}.grd"
        echo "Grade Successfully Assigned"
    fi
}

update_grade(){
    echo =====================================
    echo Choose which student grade to update:
    echo =====================================
    for std in $(ls ./sgms_data/students/)
    do
        echo $std
    done
    echo =====================================================
    while true
    do
        read -p "Type the ID of the student you want to update: " student_id
        if student_exist $student_id
        then
            break
        fi
    done
    echo =====================================================
    while true
    do
        read -p "Type the ID of the subject you want to update the grade of: " subject_id
        if subject_exist $subject_id
        then
            break
        fi
    done    
    echo =====================================================    
    while true
    do
        read -p "Type the score you want to update : " score
        if validate_score $score
        then
            break
        fi
    done
    echo =====================================================    
    L=$(score_to_letter $score)
    sed -i "/^${student_id}|/d" "./sgms_data/grades/${subject_id}.grd"
    echo "$student_id|$score|$L" >> "./sgms_data/grades/${subject_id}.grd"
    echo "Grade Successfully Updated"
}

delete_grade(){
    echo ================================
    echo Choose which student to delete:
    echo ================================
    for std in $(ls ./sgms_data/students/)
    do
        echo $std
    done
    echo =====================================================
    while true
    do
        read -p "Type the ID of the student you want to delete: " student_id
        if student_exist $student_id
        then
            break
        fi
    done
    echo =====================================================
    while true
    do
        read -p "Type the ID of the subject you want to delete the grade of: " subject_id
        if subject_exist $subject_id
        then
            break
        fi
    done    
    echo =====================================================  
    sed -i "/^${student_id}|/d" "./sgms_data/grades/${subject_id}.grd"
    echo "Grade Deleted Successfully" 
}


view_grades_by_subject(){
    echo ================================
    echo Choose which Subject to view:
    echo ================================
    while true
    do
        read -p "Type the ID of the subject you want to view the grades of: " subject_id
        if subject_exist $subject_id
        then
            break
        fi
    done
    for file in ./sgms_data/grades/${subject_id}.grd
    do
        for std_id in $(cut -d'|' -f1 "$file")
        do
            line=$(grep "^${std_id}|" "$file")
            score=$(echo "$line" | cut -d'|' -f2)
            letter=$(echo "$line" | cut -d'|' -f3)

            std_name=$(sed -n '2p' "./sgms_data/students/${std_id}.stu"  | cut -d"'" -f2)

            echo "$std_id | $std_name | $score | $letter"
        done
    done
}

view_grades_by_student(){
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
    for file in ./sgms_data/grades/*.grd
    do
        line=$(grep "^${student_id}|" "$file")
        if [[ -n "$line" ]]
        then
            std_id=$(echo "$line" | cut -d'|' -f1)
            score=$(echo "$line" | cut -d'|' -f2)
            letter=$(echo "$line" | cut -d'|' -f3)
            
            std_name=$(sed -n '2p' "./sgms_data/students/${std_id}.stu" | cut -d"'" -f2)
            
            sub_code=$(basename "$file" .grd)
            sub_name=$(sed -n '2p' "./sgms_data/subjects/${sub_code}.sub" | cut -d"'" -f2)
            
            echo "$std_id | $std_name | $sub_name | $score | $letter"
        fi
        
    done
}

# Grade Menu
grade_menu(){
    select opt in "Assign Grade to Student" "Update Grade" "Delete Grade" "View Grades by Subject" "View Grades by Student" "Exit"
    do
        case $REPLY in
            1)
            assign_grade
            ;;
            2)
            update_grade
            ;;
            3)
            delete_grade
            ;;
            4)
            view_grades_by_subject
            ;;
            5)
            view_grades_by_student
            ;;
            6)
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

# Report Functions
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
    echo "Cumulative GPA: $CGPA"

}

subject_statistics(){
    echo ================================
    echo Choose which Subject to view:
    echo ================================
    while true
    do
        read -p "Type the ID of the Subject you want to view: " subject_id
        if subject_exist $subject_id
        then
            break
        fi
    done
    echo ================================
    echo ====== Subject Statistics ======
    echo ================================
    total=0
    count=0
    avg=0
    passC=0
    pass=0
    max=0
    min=0
    countAplus=0
    countA=0
    countAminus=0
    countBplus=0
    countB=0
    countBminus=0
    countCplus=0
    countC=0
    countCminus=0
    countD=0
    countF=0
    for line in $(cat ./sgms_data/grades/${subject_id}.grd)
    do
        score=$(echo "$line" | cut -d'|' -f2)
        letter=$(echo "$line" | cut -d'|' -f3)
        
        if [[ $count -eq 0 ]]
        then
            min=$score
        fi
        
        max=$(echo "$max $score" |
        awk '{
            if ($2>$1)
                print $2
            else
                print $1
        }')
        min=$(echo "$min $score" |
        awk '{
            if ($1>$2)
                print $2
            else
                print $1
        }')

        total=$(echo "$total $score" |
        awk '{
            print $1+$2
        }')
        count=$((count+1))
        
        PassorFail=$(echo "$score" |
         awk '{
            if($1>=50)
                print "pass"
         }')
        
        if [[ "$PassorFail" == "pass" ]]
        then
            passC=$((passC+1))
        fi

        if [[ "$letter" == "A+" ]]
        then
            countAplus=$((countAplus+1))
        fi

        if [[ "$letter" == "A" ]]
        then
            countA=$((countA+1))
        fi

        if [[ "$letter" == "A-" ]]
        then
            countAminus=$((countAminus+1))
        fi

        if [[ "$letter" == "B+" ]]
        then
            countBplus=$((countBplus+1))
        fi

        if [[ "$letter" == "B" ]]
        then
            countB=$((countB+1))
        fi

        if [[ "$letter" == "B-" ]]
        then
            countBminus=$((countBminus+1))
        fi

        if [[ "$letter" == "C+" ]]
        then
            countCplus=$((countCplus+1))
        fi

        if [[ "$letter" == "C" ]]
        then
            countC=$((countC+1))
        fi

        if [[ "$letter" == "C-" ]]
        then
            countCminus=$((countCminus+1))
        fi

        if [[ "$letter" == "D" ]]
        then
            countD=$((countD+1))
        fi

        if [[ "$letter" == "F" ]]
        then
            countF=$((countF+1))
        fi
    done
    avg=$(echo "$total $count" |
    awk '{
        print $1/$2
    }')
    pass=$(echo "$passC $count" |
    awk '{
        print $1/$2
    }')
    
    echo "Average Score: $avg"
    echo "Highest Score: $max"
    echo "Lowest Score: $min"
    echo "Pass Rate: $pass"
    echo "A+: $countAplus | A: $countA | A-: $countAminus"
    echo "B+: $countBplus | B: $countB | B-: $countBminus"
    echo "C+: $countCplus | C: $countC | C-: $countCminus"
    echo "D: $countD"
    echo "F: $countF"
    echo ================================
}

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
    

    for file in ./sgms_data/students/*.stu
    do
        std_id=$(basename "$file" .stu)
        std_name=$(sed -n '2p' "$file" | cut -d"'" -f2)
        gpa=$(calculate_gpa "$std_id")
        echo "$gpa $std_id $std_name"

    done | sort -rn | head -n "$N"
}

failing_students(){
    echo ================================
    echo ======= Failing Students =======
    echo ================================
    for file in ./sgms_data/students/*.stu
        do
            std_id=$(basename "$file" .stu)
            std_name=$(sed -n '2p' "$file"  | cut -d"'" -f2)
            gpa=$(calculate_gpa "$std_id")
            fail_check=$(echo "$gpa" | awk '{
                if ($1<1.0)
                    print "fail"
            }')
            if [[ $fail_check == "fail" ]]
            then
                echo "$std_id | $std_name | GPA: $gpa"
            fi
            for grade_file in ./sgms_data/grades/*.grd
            do
                line=$(grep "^${std_id}|" "$grade_file")
                if [[ -n "$line" ]]
                then
                    letter=$(echo "$line" | cut -d'|' -f3)
                    if [[ "$letter" == "F" ]]
                    then
                        sub_code=$(basename "$grade_file" .grd)
                        echo "$std_id | $std_name | $sub_code"
                    fi
                fi
            done

        done
}

full_matrix(){
    echo =================================
    echo ======= Full Grade Matrix =======
    echo =================================
    columns="Student"
    for sub_file in ./sgms_data/subjects/*.sub
    do
        sub_name=$(sed -n '2p' "$sub_file" | cut -d"'" -f2)
        columns="$columns | $sub_name"
    done
    echo "$columns"
    for file in ./sgms_data/students/*.stu
    do
        std_id=$(basename "$file" .stu)
        std_name=$(sed -n '2p' "$file" | cut -d"'" -f2)
        row="$std_name"
        
        for sub_file in ./sgms_data/subjects/*.sub
        do
            sub_code=$(basename "$sub_file" .sub)
            line=$(grep "^${std_id}|" "./sgms_data/grades/${sub_code}.grd")
            
            if [[ -n "$line" ]]
            then
                score=$(echo "$line" | cut -d'|' -f2)
                row="$row | $score"
            else
                row="$row | -"
            fi
        done
        echo "$row"
    done
}
# Reports Menu
report_menu(){
    select opt in "Student Transcript" "Subject Statistics" "Top Students" "Failing" "Matrix" "Exit"
    do
        case $REPLY in
            1)
            student_transcript
            ;;
            2)
            subject_statistics
            ;;
            3)
            top_students
            ;;
            4)
            failing_students
            ;;
            5)
            full_matrix
            ;;
            6)
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
                grade_menu
                break
                ;;
            4)
                report_menu
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