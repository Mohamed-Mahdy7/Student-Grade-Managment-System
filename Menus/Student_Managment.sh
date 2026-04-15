#! /usr/bin/bash

student_exist() {

    local id=$1
    local found="$BASE_DIR/students/${id}.stu"
    do
        if [[ -f found ]]
            then
                echo "Error: student with id: '$id' already exists"
                return 1
        fi
    done
}