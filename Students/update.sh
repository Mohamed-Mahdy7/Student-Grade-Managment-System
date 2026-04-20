#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

shopt -s extglob
STUDENT_PATH=./sgms_data/students

student_update() {
    clear
    echo ================================
    echo Choose which student to update:
    echo ================================
    for std in "$STUDENT_PATH"/*.stu
    do
        echo "$(basename "$std")"
    done
    if [[ ! "$std" ]]
    then 
        echo "No Student Found!"
    else
        while true
        do
            echo =====================================================
            echo "hint: Type 'back' if you want to exist update menu"
            read -p "Type the ID of the student You want to update: " student_id
            echo =====================================================
            if [[ "$student_id" == 'back' ]]
            then
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break
            elif student_exist $student_id
            then 
                clear
                cat "$STUDENT_PATH"/"${student_id}".stu
                echo ==========================================
                echo Select what to update: 
                echo ==========================================
                select opt in Name Email Year Back
                do
                    case $REPLY in
                    [Nn][Aa][Mm][Ee]|1)
                        while true
                        do
                            read -p "write the new name: " new_name
                            clear
                            if validate_name "$new_name"
                            then
                                sed -i "s/^Name: .*/Name: '$new_name'/" \
                                    "$STUDENT_PATH/"${student_id}".stu"
                                
                                echo Updated!
                                echo =========================================
                                cat "$STUDENT_PATH"/"${student_id}".stu
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo "Type 4 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                    [Ee][Mm][Aa][Ii][Ll]|2)
                        while true
                        do
                            read -p "write the new email: " new_email
                            clear
                            if validate_email "$new_email"
                            then
                                sed -i "s/^Email: .*/Email: '$new_email'/" \
                                    "$STUDENT_PATH/"${student_id}".stu"
                                
                                echo Updated!
                                echo =========================================
                                cat "$STUDENT_PATH"/"${student_id}".stu
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo " Type 4 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                    [Yy][Ee][Aa][Rr]|3)
                        while true
                        do
                            read -p "write the new year: " new_year
                            clear
                            if validate_year "$new_year"
                            then
                                sed -i "s/^Year: .*/Year: '$new_year'/" \
                                    "$STUDENT_PATH"/"${student_id}".stu
                                
                                echo Updated!
                                echo =========================================
                                cat "$STUDENT_PATH"/"${student_id}".stu
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo " Type 4 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                    [Bb][Aa][Cc][Kk]|4)
                        echo "Going back..."
                        read -p "Press 'Enter' to continue..."
                        break
                        ;;
                    esac
                done
            fi
        done
    fi
}  
