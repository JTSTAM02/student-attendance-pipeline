with int_attendance as (

    select * from {{ ref('int_attendance_daily') }}

),

calendar as (

    select * from {{ ref('school_calendar_2024') }}
    where is_instructional = 1

),

-- Join attendance to calendar to only count instructional days
attendance_on_instructional_days as (

    select
        a.student_id,
        a.school_id,
        a.attendance_date,
        a.is_present,
        a.is_enrolled

    from int_attendance a
    inner join calendar c
        on a.attendance_date = c.date
        and a.school_id = c.school_id

),

ada as (

    select
        school_id,
        count(distinct attendance_date)                         as instructional_days,
        sum(is_present)                                         as total_days_present,
        sum(is_enrolled)                                        as total_days_enrolled,
        round(sum(is_present) * 100.0 / sum(is_enrolled), 2)   as ada_pct

    from attendance_on_instructional_days

    group by school_id

)

select * from ada
