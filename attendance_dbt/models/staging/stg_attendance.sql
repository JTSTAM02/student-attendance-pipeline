{{    config(
        materialized='incremental',
        incremental_strategy='insert_overwrite',
	partitioned_by=['attendance_date']
    )
}}

with source as (

    select * from {{ source('attendance_raw', 'raw_attendance') }}

    {% if is_incremental() %}
        where cast(date as date) > (
            select max(attendance_date)
            from {{ this }}
        )
    {% endif %}

),

renamed as (

    select
	{{ dbt_utils.generate_surrogate_key(['student_id', 'school_id', 'date']) }}
						as attendance_sk,
        cast(student_id as varchar)             as student_id,
        cast(school_id  as varchar)             as school_id,
        coalesce(cast(present  as integer), 0)  as is_present,
        coalesce(cast(enrolled as integer), 1)  as is_enrolled,
	cast(date	as date)		as attendance_date
	
    from source

)

select * from renamed
