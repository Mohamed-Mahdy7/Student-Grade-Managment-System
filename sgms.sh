#! /usr/bin/bash

. ./Menus/Main.sh

shopt -s extglob

BASE_DIR=$(dirname $0)/sgms_data
mkdir -p $BASE_DIR/students $BASE_DIR/subjects $BASE_DIR/grades


# main Call
while true
do
    # clear
    menu
    status=$?

    if [[ $status -eq 0 ]]
    then
        break
    else
        echo "Back to menu..."
    fi
done