{{
    config(
        materialized='incremental',
	incremental_strategy='insert_overwrite',
	partitioned_by=['attendance_date']
	)
}}

with stg as (

    select * from {{ ref('stg_attendance') }}

    {% if is_incremental() %}
        where attendance_date > (
            select max(attendance_date)
            from {{ this }}
        )
    {% endif %}

),

daily as (

    select
        student_id,
        school_id,
        is_present,
        is_enrolled,

        -- Absenteeism flag
        case
            when is_present = 0 and is_enrolled = 1
            then 1
            else 0
        end as is_absent,

        -- Truancy flag
        case
            when is_present = 0 and is_enrolled = 1
            then 1
            else 0
        end as is_truant,

	attendance_date

    from stg

)

select * from daily
