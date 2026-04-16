function score_to_letter(score){
    
    awk'
    BEGIN{
        Grade=""
    }
    {
        if($score > 89){
            Grade = "A+"
        }else if($score > 84){
            Grade = "A"
        }else if($score > 79){
            Grade = "A-"
        }else if($score > 74){
            Grade = "B+"
        }else if($score > 69){
            Grade = "B"
        }else if($score > 64){
            Grade = "B-"
        }else if($score > 59){
            Grade = "C+"
        }else if($score > 54){
            Grade = "C"
        }else if($score > 49){
            Grade = "C-"
        }else if($score > 44){
            Grade = "D"
        }else{
            Grade = "F"
        }
        return Grade
    }
    '
}

function score_to_gpa(score){
    
    awk'
    BEGIN{
        GPA=0.0
    }
    {
        if($score > 84){
            GPA = 4.0
        }else if($score > 79){
            GPA = 3.7
        }else if($score > 74){
            GPA = 3.3
        }else if($score > 69){
            GPA = 3.0
        }else if($score > 64){
            GPA = 2.7
        }else if($score > 59){
            GPA = 2.3
        }else if($score > 54){
            GPA = 2.0
        }else if($score > 49){
            GPA = 1.7
        }else if($score > 44){
            GPA = 1.0
        }else{
            GPA = 0.0
        }
        return GPA
    }
    '
}


function calculate_gpa(student_id){
    
}


function calculate_weighted_gpa(student_id){

}