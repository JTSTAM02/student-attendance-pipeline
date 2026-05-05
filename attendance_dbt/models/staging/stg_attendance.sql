with source as (

    select * from {{ source('attendance_raw', 'raw_attendance') }}

),

renamed as (

    select
        cast(student_id as varchar)   as student_id,
        cast(school_id  as varchar)   as school_id,
        cast(date       as date)      as attendance_date,
        coalesce(cast(present as integer), 0) as is_present,
        coalesce(cast(enrolled as integer), 1) as is_enrolled

    from source

)

select * from renamed
