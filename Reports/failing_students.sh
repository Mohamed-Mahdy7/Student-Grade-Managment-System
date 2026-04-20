#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

failing_students(){
    echo ================================
    echo ======= Failing Students =======
    echo ================================
    echo " ID | Name | GPA "
    for file in ./sgms_data/students/*.stu
        do
            std_id=$(basename "$file" .stu)
            std_name=$(sed -n '2p' "$file"  | cut -d"'" -f2)
            failed_sub=0
            for grade_file in ./sgms_data/grades/*.grd
            do
                sub_code=$(basename "$file" .grd)
                if ! sub_grades_not_empty "$sub_code"
                then
                    continue
                fi
                line=$(grep "^${std_id}|" "$grade_file")
                if [[ -n "$line" ]]
                then
                    letter=$(echo "$line" | cut -d'|' -f3)
                    gpa=$(calculate_gpa "$std_id")
                    failed_gpa=$(echo "$gpa" | awk '{
                        if ($1<1.0)
                            print 1
                        else
                            print 0
                    }')
                    if [[ "$letter" == "F" ]]
                    then
                        failed_sub=1
                    fi        
                fi
            done
            if [[ $failed_sub -eq 1 || $failed_gpa -eq 1 ]]
            then
                echo "$std_id | $std_name | GPA: $gpa"
            fi
        done
}
