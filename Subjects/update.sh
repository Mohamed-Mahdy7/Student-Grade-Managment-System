#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

shopt -s extglob
SUBJECT_PATH=./sgms_data/subjects

subject_update() {
    clear
    echo ================================
    echo Choose which subject to update:
    echo ================================
    for sub in "$SUBJECT_PATH"/*.sub
    do
        echo "$(basename "$sub")"
    done
    if [[ ! "$sub" ]]
    then 
        echo "No Subject Found!"
    else
        while true
        do    
            echo =====================================================
            echo "hint: Type 'back' if you want to exist update menu"
            read -p "Type the Code of the subject You want to update: " code
            echo =====================================================
            if [[ "$code" == 'back' ]]
            then
                echo "Going back..."
                read -p "Press 'Enter' to continue..."
                break
            elif subject_exist $code
            then 
                clear
                cat "$SUBJECT_PATH"/"${code}".sub
                echo ==========================================
                echo Select what to update: 
                echo ==========================================
                select opt in Name Credits Back
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
                                    "$SUBJECT_PATH"/"${code}".sub
                                
                                echo Updated!
                                echo =========================================
                                cat "$SUBJECT_PATH"/"${code}".sub
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo "Type 3 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                    [Cc][Rr][Ee][Dd][Ii][Tt][Ss]|2)
                        while true
                        do
                            read -p "write the new credits: " new_credit
                            clear
                            if validate_credit_hours "$new_credit"
                            then
                                sed -i "s/^Credits: .*/Credits: '$new_credit'/" \
                                    "$SUBJECT_PATH"/"${code}".sub
                                
                                echo Updated!
                                echo =========================================
                                cat "$SUBJECT_PATH"/"${code}".sub
                                echo =========================================
                                read -p "Press 'Enter' to continue..."
                                echo "Type 3 or 'Back' to go back..."
                                break
                            fi
                        done
                        ;;
                        [Bb][Aa][Cc][Kk]|3)
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
