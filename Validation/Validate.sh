#! /urs/bin/bash

validate_id(){
    if [[ $student_id =~ ^[0-9]{1, 10}$ ]]
    then
        if [[ -f "sgms_data/students/$student_id.stu"]]
        then 
            echo "Student with ID: ${student_id} already exists!"
        else
            echo "Valid Student ID"
        fi
    else
        echo "Student ID must be numeric from 0-9 and less than 10 digits"
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
}

validate_email(){

}

validate_year(){

}

validate_subject_code(){

}

validate_credits(){

}

validate_score() {

}