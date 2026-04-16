#! /usr/bin/bash

. ./Validation/Validate.sh

subject_exist() {
    local id="$1"
    if [[ -f "sgms_data/subjects/${id}.sub" ]]
        then
            echo "subjects with code: ${id} exists"
            return 0
    else
        echo "subjects doesn't exists"
        return 1
    fi
}

subject_add() {
    while true
    do
        echo =========================
        echo "Add new Subject"
        echo =========================
        while true
        do
            read -p "Enter Subject Code: " code
            if validate_subject_code "$code"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter Subject Name: " subject_name
            if validate_name "$subject_name"
            then
                break
            fi
        done
        echo =========================
        while true
        do
            read -p "Enter Subject Credit Hours: " credits
            if validate_credit_hours "$credits"
            then
                break
            fi
        done
        
        touch ./sgms_data/subjects/${code}.sub
        echo "Code: '$code'" >> ./sgms_data/subjects/${code}.sub
        echo "Name: '$subject_name'" >> ./sgms_data/subjects/${code}.sub
        echo "Credits: '$credits'" >> ./sgms_data/subjects/${code}.sub

        echo "Subject added successfully!"
        break
    done
}

subject_list() {
    if [[ -d ./sgms_data/subjects/ ]]
    then
        if [[ `ls ./sgms_data/subjects/` == "" ]]
        then 
            echo "No Subjects yet!"
        else
            ls ./sgms_data/subjects/
        fi
    else
        echo "Subjects directory not found!"
    fi
}

subject_update() {
    echo ================================
    echo Choose which subject to update:
    echo ================================
    for sub in $(ls ./sgms_data/subjects/)
    do
        echo $sub
    done
    echo =====================================================
    read -p "Type the Code of the subject You want to update: " code
    echo ==========================================
    if subject_exist $code
    then 
        cat ./sgms_data/subjects/${code}.sub
        echo ==========================================
        echo Select what to update: 
        echo ==========================================
        select opt in Name Credits
        do
            case $REPLY in
            [Nn][Aa][Mm][Ee]|1)
                while true
                do
                    read -p "write the new name: " new_name
                    if validate_name "$new_name"
                    then
                        sed -i "s/^Name: .*/Name: '$new_name'/" \
                            "./sgms_data/subjects/${code}.sub"
                        
                        echo Updated!
                        echo =========================================
                        cat ./sgms_data/subjects/${code}.sub
                        echo =========================================
                        break
                    fi
                done
                ;;
            [Cc][Rr][Ee][Dd][Ii][Tt][Ss]|2)
                while true
                do
                    read -p "write the new credits: " new_credit
                    if validate_credit_hours "$new_credit"
                    then
                        sed -i "s/^Credits: .*/Credits: '$new_credit'/" \
                            "./sgms_data/subjects/${code}.sub"
                        
                        echo Updated!
                        echo =========================================
                        cat ./sgms_data/subjects/${code}.sub
                        echo =========================================
                        break
                    fi
                done
                ;;
            esac
        done
    fi
}

subject_delete() {
    echo ==================================
    echo Choose which subject to delete: 
    echo ==================================
    for std in $(ls ./sgms_data/subjects/)
    do
        echo $std
    done
    echo ===================================================
    while true
    do
        read -p "Type the Code of the subject you want to delete: " code
        echo ===================================================
        if subject_exist $code
        then
            read -p "Are you sure You want to delete subject: ${code}? (y|n): " answer
            if [[ $answer == "y" ]]
            then
                rm ./sgms_data/subjects/${code}.sub
                echo Deleted!
                break
            elif [[ $answer == "n" ]]
            then
                break
            else
                continue
            fi
        fi
    done
}


subject_menu() {
    echo Subject Menu
    echo ================================================================
    echo Select the number or the word of the operation you want to do?
    echo ================================================================
    select opt in Add List Update Delete Exit
    do 
        case $REPLY in
        [Aa][Dd][Dd]|1)
            subject_add
            ;;
        [Ll][Ii][Ss][Tt]|2)
            subject_list
            ;;
        [Uu][Pp][Dd][Aa][Tt][Ee]|3)
            subject_update
            ;;
        [Dd][Ee][Ll][Ee][Tt][Ee]|4)
            subject_delete
            ;;
        [Ee][Xx][Ii][Tt]|5)
            echo "exiting..."
            return 0
            ;;
        *)
            echo Invalid Selection!
            echo Try Again
            continue
            ;;
        esac
    done
}
