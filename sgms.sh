#! /usr/bin/bash

BASE_DIR=$(dirname $0)/sgms_data
mkdir -p $BASE_DIR/students $BASE_DIR/subjects $BASE_DIR/grades

validate_id(){
    local id="$1"
    if [[ "$id" =~ ^[0-9]{1,10}$ ]]
    then
        if [[ -f "sgms_data/students/$student_id.stu" ]]
        then 
            echo "Student with ID: ${student_id} already exists!"
            return 1
        else
            echo "Valid Student ID"
            return 0
        fi
    else
        echo "Student ID must be numeric from 0-9 and less than 10 digits"
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
        echo "Student Name shouldn't be empty or only spaces, only printable characters"
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
        echo "Invalid Email"
        return 1
    fi
}

validate_year(){
    local year="$1"
    if [[ "$year" =~ ^[0-9]{1,6}$ ]]
    then
        echo "Valid year"
        return 0
    else
        echo "Invalid year"
        return 1
    fi
}

validate_subject_code(){
    local code="$1"
    if [[ "$code" =~ ^[A-Z]{2,5}[0-9]{2,4}$ ]]
    then
        if [[ -f "sgms_data/subjects/$code.sub" ]]
        then 
            echo "Subject with Code: ${code} already exists!"
            return 1
        else
            echo "Valid Subject Code"
            return 0
        fi
    else
        echo "Invalid Subject Code"
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
        echo "Invalid Credits"
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
        echo "Invalid Score"
        return 1
    fi
}

student_exist() {
    local id="$1"
    if [[ -f "sgms_data/students/${id}.stu" ]]
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
        if [[ $(ls ./sgms_data/students/) == "" ]]
        then 
            echo "No Students yet!"
        else
            ls ./sgms_data/students/
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
    if [[ $(ls ./sgms_data/students/) == "" ]]
    then 
        echo "No Students yet!"
    else
        student=$(grep -H "Name:.*$student_name" ./sgms_data/students/*)
        if [[ -z "$student" ]]
        then
            echo "Student not found!"
        else
            matched=($(echo "$student" | cut -d: -f1 | sort -u))
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
                    cat "$f"
                    break
                done
            else
                echo
                cat "${matched[0]}"
            fi
        fi
    fi
}


student_update() {
    echo ================================
    echo Choose which student to update:
    echo ================================
    for std in $(ls ./sgms_data/students/)
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
                cat ./sgms_data/students/${student_id}.stu
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
                                    "./sgms_data/students/${student_id}.stu"
                                
                                echo Updated!
                                echo =========================================
                                cat ./sgms_data/students/${student_id}.stu
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
                                    "./sgms_data/students/${student_id}.stu"
                                
                                echo Updated!
                                echo =========================================
                                cat ./sgms_data/students/${student_id}.stu
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
                                    "./sgms_data/students/${student_id}.stu"
                                
                                echo Updated!
                                echo =========================================
                                cat ./sgms_data/students/${student_id}.stu
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
    for std in $(ls ./sgms_data/students/)
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
                rm ./sgms_data/students/${student_id}.stu
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
    if [[ -f "sgms_data/subjects/${id}.sub" ]]
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
        
        touch ./sgms_data/subjects/${code}.sub
        echo "Code: '$code'" >> ./sgms_data/subjects/${code}.sub
        echo "Name: '$subject_name'" >> ./sgms_data/subjects/${code}.sub
        echo "Credits: '$credits'" >> ./sgms_data/subjects/${code}.sub

        echo "Subject added successfully!"
        break
    done
}

subject_list() {
    if [[ -d ./sgms_data/subjects/ ]]
    then
        if [[ `ls ./sgms_data/subjects/` == "" ]]
        then 
            echo "No Subjects yet!"
        else
            ls ./sgms_data/subjects/
        fi
    else
        echo "Subjects directory not found!"
    fi
}

subject_update() {
    echo ================================
    echo Choose which subject to update:
    echo ================================
    for sub in $(ls ./sgms_data/subjects/)
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
                cat ./sgms_data/subjects/${code}.sub
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
                                    "./sgms_data/subjects/${code}.sub"
                                
                                echo Updated!
                                echo =========================================
                                cat ./sgms_data/subjects/${code}.sub
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
                                    "./sgms_data/subjects/${code}.sub"
                                
                                echo Updated!
                                echo =========================================
                                cat ./sgms_data/subjects/${code}.sub
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
    for std in $(ls ./sgms_data/subjects/)
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
                rm ./sgms_data/subjects/${code}.sub
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

# Grade Helpers

sub_grades_exists(){
    local id="$1"
    if [[ -f "sgms_data/grades/${id}.grd" ]]
        then
            echo "Subject grades file with code: ${id} exists"
            return 0
    else
        touch "sgms_data/grades/${id}.grd"
        echo "Subject grades file with code: ${id} created"
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
        print GPA
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
                    print $1+$2
                }
                ')
                count=$((count+1))
            fi            
        done
        echo "$total $count" |
            awk '
            {
                print $1/$2
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
                    print $1+$2
                }
                ')
            fi
        done
        echo "$total $count" |
            awk '
            {
                print $1/$2
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
        sed -i "\$a $student_id|$score|$L" "./sgms_data/grades/${subject_id}.grd"
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
    sed -i "\$a $student_id|$score|$L" "./sgms_data/grades/${subject_id}.grd"
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

            std_name=$(sed -n '2p' "./sgms_data/students/${std_id}.stu")

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
            
            std_name=$(sed -n '2p' "./sgms_data/students/${std_id}.stu")
            
            sub_code=$(basename "$file" .grd)
            sub_name=$(sed -n '2p' "./sgms_data/subjects/${sub_code}.sub")
            
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
            sub_name=$(sed -n '2p' "./sgms_data/subjects/${sub_code}.sub")

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
        }')
        min=$(echo "$min $score" |
        awk '{
            if ($1>$2)
                print $2
        }')

        total=$(echo "$total $score" |
        awk '{
            print $1+$2
        }')
        count=$((count+1))
        
        if [[$score>=50]]
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

# Reports Menu
report_menu(){
    select opt in "Student Transcript" "Subject Statistics" "Top" "Failing" "Matrix" "Exit"
    do
        case $REPLY in
            1)
            student_transcript
            ;;
            2)
            subject_statistics
            ;;
            3)
            ;;
            4)
            ;;
            5)
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
            grade_menu
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