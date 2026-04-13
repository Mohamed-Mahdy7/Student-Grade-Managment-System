# Student Grade Management System (SGMS)

A CLI menu-based Bash application for managing students, subjects, and grades using flat-file storage — no external databases required.

---

## What This Project Is

SGMS is a single Bash script (`sgms.sh`) that runs entirely in the terminal. It lets users manage student records, define subjects with credit hours, assign and update grades, and generate statistical reports including GPA calculations, subject averages, and ranked student lists.

---

## How to Run

```bash
chmod +x sgms.sh
./sgms.sh
```

The script auto-creates all required directories (`sgms_data/`) on the first run. No setup beyond that is needed.

---

## Project Requirements Summary

| Requirement | Detail |
|---|---|
| Single script | Everything in `sgms.sh` — no multi-file splits |
| Permissions | Must be directly executable (`chmod +x`) |
| Storage | Flat files under `sgms_data/` — no external DB |
| Paths | Relative paths only — no hardcoded absolute paths |
| Input validation | All fields validated in `while true` loops |
| GPA math | Must use `awk` — never shell arithmetic for floats |
| Grade file format | Pipe-delimited rows: `student_id\|score\|letter` |

---

## Application Menu Structure

```
Main Menu
├── Manage Students
│   ├── Add / List / Update / Delete Student
├── Manage Subjects
│   ├── Add / List / Update / Delete Subject
├── Manage Grades
│   ├── Assign / Update / Delete Grade
│   ├── View Grades by Subject
│   └── View Grades by Student
├── Reports & Statistics
│   ├── Student Transcript + GPA
│   ├── Subject Statistics
│   ├── Top Students by GPA
│   ├── Failing Students Report
│   └── Full Grade Matrix
└── Exit
```

---

## Team Work Split

> Full technical details, function signatures, file formats, and deliverables are in **SGMS_Team_Contract.docx** — read that before writing any code.

The project is divided into two parallel tracks. The only shared dependency is a brief contract agreement at the start (file formats + four helper function signatures). After that, both developers work independently.

### Person A — Foundation, Validation & CRUD

Owns the entire base layer of the application:

- **Bootstrap** — directory auto-creation, main menu skeleton, script entry point
- **Validation library** — all input validation functions used by both developers
- **Student CRUD** — full Add / List / Update / Delete for students
- **Subject CRUD** — full Add / List / Update / Delete for subjects
- **Bonus (optional)** — partial name search using `grep`

### Person B — Grades, GPA & Reports

Owns all data processing and output:

- **Grade helper functions** — `score_to_letter()`, `score_to_gpa()`, GPA calculation via `awk`
- **Grade CRUD** — Assign / Update / Delete grades, View by subject, View by student
- **Reports 1 & 2** — Student Transcript + GPA, Subject Statistics
- **Reports 3, 4 & 5** — Top Students, Failing Students, Full Grade Matrix
- **Bonus (optional)** — Export any report to `.txt` or `.csv`

---

## Integration

When both tracks are complete, the team merges everything into a single `sgms.sh` and runs the full integration checklist defined in the contract document before submission.

---

## Submission Checklist

- [ ] `sgms.sh` exists and is executable
- [ ] `sgms_data/` is auto-created on first run
- [ ] Script uses only relative paths
- [ ] All validation rules enforced
- [ ] All menus functional
- [ ] All five reports working correctly
- [ ] Code is clean and well-commented
