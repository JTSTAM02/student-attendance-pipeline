{% snapshot student_enrollment_snapshot %}

{{
    config(
        target_schema='attendance_db',
        unique_key='student_id',
        strategy='check',
        check_cols=['school_id', 'grade_level', 'is_active'],
        invalidate_hard_deletes=True
    )
}}

select
    student_id,
    school_id,
    grade_level,
    enrollment_date,
    is_active,
    current_date as updated_at

from {{ ref('student_enrollment') }}

{% endsnapshot %}
