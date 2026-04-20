#! /usr/bin/bash

. ./Helpers/helpers.sh
. ./Validation/Validate.sh

subject_statistics(){
    echo ================================
    echo Choose which Subject to view:
    echo ================================
    while true
    do
        read -p "Type the Code of the Subject you want to view: " subject_id
        if subject_exist $subject_id
        then
            if sub_grades_exists $subject_id && $sub_grades_not_empty $subject_id
            then
                break
            fi
        fi
    done
    echo ================================
    echo ====== Subject Statistics ======
    echo ================================
    total=0
    count=0
    avg=0
    passC=0
    pass=0
    max=0
    min=0
    countAplus=0
    countA=0
    countAminus=0
    countBplus=0
    countB=0
    countBminus=0
    countCplus=0
    countC=0
    countCminus=0
    countD=0
    countF=0
    for line in $(cat ./sgms_data/grades/"${subject_id}".grd)
    do
        score=$(echo "$line" | cut -d'|' -f2)
        letter=$(echo "$line" | cut -d'|' -f3)
        
        if [[ $count -eq 0 ]]
        then
            min=$score
        fi
        
        max=$(echo "$max $score" |
        awk '{
            if ($2>$1)
                print $2
            else
                print $1
        }')
        min=$(echo "$min $score" |
        awk '{
            if ($1>$2)
                print $2
            else
                print $1
        }')

        total=$(echo "$total $score" |
        awk '{
            print $1+$2
        }')
        count=$((count+1))
        
        PassorFail=$(echo "$score" |
         awk '{
            if($1>=50)
                print "pass"
         }')
        
        if [[ "$PassorFail" == "pass" ]]
        then
            passC=$((passC+1))
        fi

        if [[ "$letter" == "A+" ]]
        then
            countAplus=$((countAplus+1))
        fi

        if [[ "$letter" == "A" ]]
        then
            countA=$((countA+1))
        fi

        if [[ "$letter" == "A-" ]]
        then
            countAminus=$((countAminus+1))
        fi

        if [[ "$letter" == "B+" ]]
        then
            countBplus=$((countBplus+1))
        fi

        if [[ "$letter" == "B" ]]
        then
            countB=$((countB+1))
        fi

        if [[ "$letter" == "B-" ]]
        then
            countBminus=$((countBminus+1))
        fi

        if [[ "$letter" == "C+" ]]
        then
            countCplus=$((countCplus+1))
        fi

        if [[ "$letter" == "C" ]]
        then
            countC=$((countC+1))
        fi

        if [[ "$letter" == "C-" ]]
        then
            countCminus=$((countCminus+1))
        fi

        if [[ "$letter" == "D" ]]
        then
            countD=$((countD+1))
        fi

        if [[ "$letter" == "F" ]]
        then
            countF=$((countF+1))
        fi
    done
    avg=$(echo "$total $count" |
    awk '{
        print $1/$2
    }')
    pass=$(echo "$passC $count" |
    awk '{
        print $1/$2
    }')
    
    echo "Average Score: $avg"
    echo "Highest Score: $max"
    echo "Lowest Score: $min"
    echo "Pass Rate: $pass"
    echo "A+: $countAplus | A: $countA | A-: $countAminus"
    echo "B+: $countBplus | B: $countB | B-: $countBminus"
    echo "C+: $countCplus | C: $countC | C-: $countCminus"
    echo "D: $countD"
    echo "F: $countF"
    echo ================================
}
