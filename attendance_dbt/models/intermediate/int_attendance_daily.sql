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
        attendance_sk,
	student_id,
        school_id,
        is_present,
        is_enrolled,

	{{ is_absent_flag('is_present', 'is_enrolled') }} as is_absent,
	{{ is_truant_flag('is_present', 'is_enrolled') }} as is_truant,

	attendance_date

    from stg

)

select * from daily
