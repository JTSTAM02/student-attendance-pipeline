with int_attendance as (

    select * from {{ ref('int_attendance_daily') }}

),

adm as (

    select
        school_id,
        attendance_date,
        sum(is_enrolled)                as enrolled_count,
        sum(is_present)                 as present_count

    from int_attendance

    group by school_id, attendance_date

),

adm_summary as (

    select
        school_id,
        count(distinct attendance_date)         as total_days,
        round(avg(enrolled_count), 2)           as avg_daily_membership,
        round(avg(present_count), 2)            as avg_daily_attendance

    from adm

    group by school_id

)

select * from adm_summary
