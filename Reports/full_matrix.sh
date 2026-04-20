#! /usr/bin/bash

full_matrix(){
    echo =================================
    echo ======= Full Grade Matrix =======
    echo =================================
    columns="Student"
    for sub_file in ./sgms_data/subjects/*.sub
    do
        sub_name=$(sed -n '2p' "$sub_file" | cut -d"'" -f2)
        columns="$columns | $sub_name"
    done
    echo "$columns"
    for file in ./sgms_data/students/*.stu
    do
        std_id=$(basename "$file" .stu)
        std_name=$(sed -n '2p' "$file" | cut -d"'" -f2)
        row="$std_name"
        
        for sub_file in ./sgms_data/subjects/*.sub
        do
            sub_code=$(basename "$sub_file" .sub)
            line=$(grep "^${std_id}|" "./sgms_data/grades/${sub_code}.grd")
            
            if [[ -n "$line" ]]
            then
                score=$(echo "$line" | cut -d'|' -f2)
                row="$row | $score"
            else
                row="$row | -"
            fi
        done
        echo "$row"
    done
}
