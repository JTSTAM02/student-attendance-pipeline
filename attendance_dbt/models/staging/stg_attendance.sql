with source as (

    select * from {{ source('attendance_raw', 'raw_attendance') }}

),

renamed as (

    select
        cast(student_id as varchar)   as student_id,
        cast(school_id  as varchar)   as school_id,
        cast(date       as date)      as attendance_date,
        cast(present    as integer)   as is_present,
        cast(enrolled   as integer)   as is_enrolled

    from source

)

select * from renamed
