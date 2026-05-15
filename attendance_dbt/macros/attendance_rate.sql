-- macros/attendance_rate.sql
-- Reusable formula for calculating attendance rate as a percentage.
-- Uses nullif to prevent division-by-zero errors when enrolled_days = 0.
--
-- Usage: {{ attendance_rate('present_days', 'enrolled_days') }}

{% macro attendance_rate(present_col, enrolled_col) %}
    round(
        100.0 * {{ present_col }} / nullif({{ enrolled_col }}, 0),
        2
    )
{% endmacro %}
