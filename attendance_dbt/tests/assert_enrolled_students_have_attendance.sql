-- tests/assert_enrolled_students_have_attendance.sql
-- Any student marked as enrolled must have an attendance record (present or absent).
-- An enrolled student with neither flag set = missing data.
-- Returns violating rows — any result = test failure.

select
    student_id,
    school_id,
    attendance_date,
    is_enrolled,
    is_present,
    is_absent
from {{ ref('int_attendance_daily') }}
where is_enrolled = 1
  and is_present = 0
  and is_absent = 0
