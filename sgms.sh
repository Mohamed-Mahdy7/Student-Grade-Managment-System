#! /usr/bin/bash

BASE_DIR=$(dirname $0)/sgms_data
mkdir -p $BASE_DIR/students $BASE_DIR/subjects $BASE_DIR/grades

. ./Menus/Main.sh

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