with current_enrollment as (

    select
        student_id,
        school_id,
        grade_level,
        enrollment_date,
        is_active,
        dbt_valid_from      as enrolled_from,
        dbt_valid_to        as enrolled_to,

        -- is_current flag for easy filtering
        case
            when dbt_valid_to is null then 1
            else 0
        end                 as is_current_enrollment

    from {{ ref('student_enrollment_snapshot') }}

)

select * from current_enrollment
order by student_id, enrolled_from
