#! /urs/bin/bash

validate_id(){
    if [[ $student_id =~ ^[0-9]{1,10}$ ]]
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
    if [[ -n $student_name && ! $student_name =~ ^[[:space:]]+$ ]]
    then
        echo "Valid Student Name"
        return 0
    else
        echo "Student Name shouldn't be empty or only spaces, only printable characters"
        return 1
    fi
}

validate_email(){
    if [[ $email =~ ^[^@]+@[^@]+\.[^@]+$  ]]
    then
        echo "Valid Email"
        return 0
    else
        echo "Invalid Email"
        return 1
    fi
}

validate_year(){
    if [[ $year =~ ^[0-9]{1,6}$ ]]
    then
        echo "Valid year"
        return 0
    else
        echo "Invalid year"
        return 1
    fi
}

validate_subject_code(){
    if [[ $year =~ ^[A-Z]{2,5}[0-9]{2,4}$ ]]
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
        echo "Invalid Subject Code"
    fi
}

validate_credit_hours(){
    if [[ $credit_hours =~ ^[0-6]$ ]]
    then
        echo "Valid Credits"
        return 0
    else
        echo "Invalid Credits"
        return 1
    fi
}

validate_score() {
    if [[ $grade_score =~ ^[0-9]+(\.[0-9]+)?$ ]] && \
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