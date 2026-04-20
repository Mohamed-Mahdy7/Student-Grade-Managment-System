#! /usr/bin/bash

shopt -s extglob
STUDENT_PATH=./sgms_data/students
SUBJECT_PATH=./sgms_data/subjects

validate_id(){
    id="$1"
    if [[ "$id" =~ ^[0-9]{1,10}$ ]]
    then
        if [[ -f "$STUDENT_PATH"/$id.stu ]]
        then 
            echo "Student with ID: ${id} already exists!"
            return 1
        else
            # echo "Valid Student ID"
            return 0
        fi
    else
        echo "Error: Student ID must be numeric from 0-9 and less than 10 digits"
        return 1
    fi
}

validate_name(){
    name="$1"
    if [[ $name =~ ^[A-Za-z]+[[:space:]A-Za-z0-9-]+$ ]]
    then
        # echo "Valid Student Name"
        return 0
    else
        echo "Error: Student Name shouldn't be empty or only spaces,"
        echo "Only printable characters allowed, ex) Ahmed Ali"
        return 1
    fi
}

validate_email(){
    email="$1"
    if [[ "$email" =~ ^[a-z][a-z0-9._%+-]*@[a-z0-9.-]+\.[a-z]{2,}$ ]]
    then
        # echo "Valid Email"
        return 0
    else
        echo "Error: Email Must contain @ and domain dot,"
        echo "only lowercase characters, numbers (_,%,-) allowed."
        echo "ex) user@domain.ext"
        return 1
    fi
}

validate_year(){
    year="$1"
    if [[ "$year" =~ ^[1-6]$ ]]
    then
        # echo "Valid year"
        return 0
    else
        echo "Error: Year must be a number from 1-6"
        return 1
    fi
}

validate_subject_code(){
    code="$1"
    if [[ "$code" =~ ^[A-Z]{2,5}[0-9]{2,4}$ ]]
    then
        if [[ -f "$SUBJECT_PATH"/$code.sub ]]
        then 
            echo "Subject with Code: ${code} already exists!"
            return 1
        else
            # echo "Valid Subject Code"
            return 0
        fi
    else
        echo "Error: Code must start with uppercase letters (2-5) + (2-4) numbers "
        return 1
    fi
}

validate_credit_hours(){
    hours="$1"
    if [[ "$hours" =~ ^[1-6]$ ]]
    then
        # echo "Valid Credits"
        return 0
    else
        echo "Error: Credits must be a number from 1-6"
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
        # echo "Valid Score"
        return 0
    else
        echo "Error: Score must be float number (0.0 - 100.0)"
        return 1
    fi
}