#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

shopt -s extglob
SUBJECT_PATH=./sgms_data/subjects

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