#! /usr/bin/bash

stubject_exist() {
    local id=$1
    local found="$BASE_DIR/subjects/${code}.stu"
    do
        if [[ -f found ]]
            then
                echo "Error: subject with code: '$code' already exists"
                return 1
        fi
    done
}