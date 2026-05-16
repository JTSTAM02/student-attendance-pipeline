-- tests/assert_not_absent_and_present_simultaneously.sql
-- A student cannot be marked both present and absent on the same day.
-- This would indicate a data quality issue in the source system.
-- Returns rows that violate this rule — any result = test failure.

select
    student_id,
    attendance_date,
    is_present,
    is_absent
from {{ ref('int_attendance_daily') }}
where is_present = 1
  and is_absent = 1
