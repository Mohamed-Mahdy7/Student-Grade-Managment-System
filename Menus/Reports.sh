#! /usr/bin/bash
. ./Reports/failing_students.sh
. ./Reports/full_matrix.sh
. ./Reports/student_transcript.sh
. ./Reports/subject_statistics.sh
. ./Reports/top_student.sh


report_menu(){
    select opt in "Student Transcript" "Subject Statistics" "Top Students" "Failing" "Matrix" "Exit"
    do
        case $REPLY in
            1)
            student_transcript
            ;;
            2)
            subject_statistics
            ;;
            3)
            top_students
            ;;
            4)
            failing_students
            ;;
            5)
            full_matrix
            ;;
            6)
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
