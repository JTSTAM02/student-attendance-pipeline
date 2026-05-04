with int_attendance as (

    select * from {{ ref('int_attendance_daily') }}

),

ada as (

    select
        school_id,
        count(distinct attendance_date)                         as total_days,
        sum(is_present)                                         as total_days_present,
        sum(is_enrolled)                                        as total_days_enrolled,
        round(sum(is_present) * 100.0 / sum(is_enrolled), 2)   as ada_pct

    from int_attendance

    group by school_id

)

select * from ada
