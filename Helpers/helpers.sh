#! /usr/bin/bash
shopt -s extglob
STUDENT_PATH=./sgms_data/students
SUBJECT_PATH=./sgms_data/subjects
GRADE_PATH=./sgms_data/grades

student_exist() {
    id="$1"
    if [[ -f "$STUDENT_PATH"/"${id}".stu ]]
        then
            # echo "student with id: ${id} exists" 
            return 0
    else
        echo "student doesn't exists"
        return 1
    fi
}

subject_exist() {
    id="$1"
    if [[ -f "$SUBJECT_PATH"/"${id}".sub ]]
        then
            # echo "subjects with code: ${id} exists"
            return 0
    else
        echo "subjects doesn't exists"
        return 1
    fi
}

sub_grades_exists(){
    local id="$1"
    if [[ -f "$GRADE_PATH/${id}.grd" ]]
        then
            # echo "Subject grades file with code: ${id} exists"
            return 0
    else
        echo "Error: Subject grades file with code: ${id} does not exist"
        return 1
    fi
}

score_to_letter(){
    
    echo "$1" | awk '
    {
        score = $1
        grade=""

        if(score >= 90){
            grade = "A+"
        }else if(score >= 85){
            grade = "A"
        }else if(score >= 80){
            grade = "A-"
        }else if(score >= 75){
            grade = "B+"
        }else if(score >= 70){
            grade = "B"
        }else if(score >= 65){
            grade = "B-"
        }else if(score >= 60){
            grade = "C+"
        }else if(score >= 55){
            grade = "C"
        }else if(score >= 50){
            grade = "C-"
        }else if(score >= 45){
            grade = "D"
        }else{
            grade = "F"
        }
        print grade
    }
    '
}

score_to_gpa(){
    
    echo "$1" | awk '
    {
        score = $1
        GPA = 0.0

        if(score >= 85){
            GPA = 4.0
        }else if(score >= 80){
            GPA = 3.7
        }else if(score >= 75){
            GPA = 3.3
        }else if(score >= 70){
            GPA = 3.0
        }else if(score >= 65){
            GPA = 2.7
        }else if(score >= 60){
            GPA = 2.3
        }else if(score >= 55){
            GPA = 2.0
        }else if(score >= 50){
            GPA = 1.7
        }else if(score >= 45){
            GPA = 1.0
        }else{
            GPA = 0.0
        }
        printf "%.1f\n", GPA
    }
    '
}

calculate_gpa(){
    local std_id="$1"
    local total=0
    local count=0
    if student_exist "$std_id"; then
        for file in ./sgms_data/grades/*.grd
        do
            line=$(grep "^${std_id}|" "$file")
            if [[ -n "$line" ]]
            then
                score=$(echo "$line" | cut -d'|' -f2)
                gpa=$(score_to_gpa "$score")
                total=$(echo "$total $gpa" |
                awk '
                {
                    printf "%.2f\n", $1+$2
                }
                ')
                count=$((count+1))
            fi            
        done
        if [[ $count -eq 0 ]]
        then
            echo Error: Student has no grades
        else
            echo "$total $count" |
            awk '
            {
                printf "%.2f\n", $1/$2
            }
            '
        fi
    fi
}

calculate_weighted_gpa(){
    local std_id="$1"
    local total=0
    local count=0
    if student_exist "$std_id"
    then
        for file in ./sgms_data/grades/*.grd
        do
            grade_line=$(grep "^${std_id}|" "$file")
            if [[ -n "$grade_line" ]]
            then
                score=$(echo "$grade_line" | cut -d'|' -f2)
                gpa=$(score_to_gpa "$score")
                sub_code=$(basename "$file" .grd)
                credits=$(sed -n '3p' "./sgms_data/subjects/${sub_code}.sub" | cut -d"'" -f2)
                if [[ $credits -eq 0 ]]
                then
                    echo Error: Subject has no credits
                else
                    total=$(echo "$total $gpa $credits" |
                    awk '
                    {
                        print $1+($2*$3)
                    }
                    ')
                    count=$(echo "$count $credits" |
                    awk '
                    {
                        printf "%.2f\n", $1+$2
                    }
                    ')
                fi
            fi
        done
        if [[ $count -eq 0 ]]
        then
            echo Error: Student has no grades
        else
            echo "$total $count" |
            awk '
            {
                printf "%.2f\n", $1/$2
            }
            '
        fi
    fi
}
