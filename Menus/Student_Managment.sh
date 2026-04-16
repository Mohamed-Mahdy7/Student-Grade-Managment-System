#! /usr/bin/bash

student_exist() {

    # local id=$1
    # local found="$BASE_DIR/students/${id}.stu"
    do
        if [[ -f "sgms_data/students/${1}.stu" ]]
            then
                echo "student with id: ${1} exists"
                return 0
        else
            echo "student doesn't exists"
            return 1
        fi
    done
}