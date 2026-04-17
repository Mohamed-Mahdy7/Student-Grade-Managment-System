. ./Menus/Student_Managment.sh

function sub_grades_exists(){
    local id = "$1"
    if [[ -f "sgms_data/grades/${id}.grd" ]]
        then
            echo "Subject grades file with code: ${id} exists"
            return 0
    else
        touch "sgms_data/grades/${id}.grd"
        echo "Subject grades file with code: ${id} created"
        return 1
    fi
}

function score_to_letter(){
    
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

function score_to_gpa(){
    
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
        print GPA
    }
    '
}


# function calculate_gpa(){
#     local std_id="$1"
#     local total=0
#     local count=0
#     if student_exist "$std_id"; then
#         for file in ./sgms_data/grades/*.grd
#         do
#             awk '
#             {
#                 total = score_to_gpa $3
#                 count = count + 1
#             }
#             ' $file
#         done
#         print total/count
#     fi
# }


# function calculate_weighted_gpa(){

# }