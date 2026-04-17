. ./Menus/Student_Managment.sh
. ./Menus/Subject_Managment.sh
. ./Validation/Validate.sh
. ./Grade_Managment/Grade_Functions.sh

function assign_grade(){
    echo ================================
    echo Choose which student to assign:
    echo ================================
    for std in $(ls ./sgms_data/students/)
    do
        echo $std
    done
    echo =====================================================
    read -p "Type the ID of the student you want to assign: " student_id
    echo =====================================================
    if student_exist $student_id
    then
        echo =====================================================
        read -p "Type the ID of the subject you want to assign the grade to: " subject_id
        echo =====================================================
        if subject_exist $subject_id
        then
            sub_grades_exists $subject_id
            echo =====================================================
            read -p "Type the score you want to assign to the student : " score
            echo =====================================================
            if validate_score $score
            then
                L=$(score_to_letter $score)
                if grep -q "^student_id " "./sgms_data/grades/${subject_id}.grd";
                then
                    echo "This student is already assigned"
                else
                    sed -i "\$a $student_id | $score | $L" "./sgms_data/grades/${subject_id}.grd"
                    echo "Grade Successfully Assigned"
            fi
        fi
    fi    
}

function update_grade(){
    echo =====================================
    echo Choose which student grade to update:
    echo =====================================
    for std in $(ls ./sgms_data/students/)
    do
        echo $std
    done
    echo =====================================================
    read -p "Type the ID of the student you want to update: " student_id
    echo =====================================================
    if student_exist $student_id
    then
        echo =====================================================
        read -p "Type the ID of the subject you want to update the grade to: " subject_id
        echo =====================================================
        if subject_exist $subject_id
        then
            sub_grades_exists $subject_id
            echo =====================================================
            read -p "Type the score you want to assign to the student : " score
            echo =====================================================
            if validate_score $score
            then
                L=$(score_to_letter $score)
                sed -i "/^$student_id /d" "./sgms_data/grades/${subject_id}.grd"
                sed -i "\$a $student_id | $score | $L" "./sgms_data/grades/${subject_id}.grd"
                echo "Grade Successfully Updated"
            fi
        fi
    fi 
}

function delete_grade(){
    echo ================================
    echo Choose which student to delete:
    echo ================================
    for std in $(ls ./sgms_data/students/)
    do
        echo $std
    done
    echo =====================================================
    read -p "Type the ID of the student you want to delete: " student_id
    echo =====================================================
    if student_exist $student_id
    then
        echo =====================================================
        read -p "Type the ID of the subject you want to delete the grade to: " subject_id
        echo =====================================================
        if subject_exist $subject_id
        then
            sed -i "/^$student_id /d" "./sgms_data/grades/${subject_id}.grd"
            echo "Grade Deleted Successfully"
        fi
    fi 
}