with int_attendance as (

    select * from {{ ref('int_attendance_daily') }}

),

truancy as (

    select
        school_id,
        student_id,
        sum(is_absent)                          as total_absences,
        sum(is_truant)                          as total_truancy_days,
        sum(is_enrolled)                        as total_days_enrolled,
        round(sum(is_absent) * 100.0 /
              nullif(sum(is_enrolled), 0), 2)   as absence_rate_pct,

        -- Chronic absenteeism = missing 10% or more of school days
        case
            when round(sum(is_absent) * 100.0 /
                 nullif(sum(is_enrolled), 0), 2) >= 10
            then 1
            else 0
        end                                     as is_chronically_absent

    from int_attendance

    group by school_id, student_id

)

select * from truancy
