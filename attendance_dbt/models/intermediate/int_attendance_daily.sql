with stg as (

    select * from {{ ref('stg_attendance') }}

),

daily as (

    select
        student_id,
        school_id,
        attendance_date,
        is_present,
        is_enrolled,

        -- Absenteeism flag
        case
            when is_present = 0 and is_enrolled = 1
            then 1
            else 0
        end as is_absent,

        -- Truancy flag (unexcused absence - for now same as absent)
        case
            when is_present = 0 and is_enrolled = 1
            then 1
            else 0
        end as is_truant

    from stg

)

select * from daily
