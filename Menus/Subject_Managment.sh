#! /usr/bin/bash

stubject_exist() {
    # local id=$1
    # local found="$BASE_DIR/subjects/${code}.sub"
    do
        if [[ -f "sgms_data/subjects/${1}.sub" ]]
            then
                echo "subjects with code: ${1} exists"
                return 0
        else
            echo "subjects doesn't exists"
            return 1
        fi
    done
}