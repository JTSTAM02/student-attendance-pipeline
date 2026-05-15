-- macros/is_chronically_absent.sql
-- Returns a boolean flag for chronic absenteeism.
-- Default threshold is 10% (federal definition) but can be overridden.
--
-- Usage: {{ is_chronically_absent('absent_days', 'enrolled_days') }}
-- Custom threshold: {{ is_chronically_absent('absent_days', 'enrolled_days', threshold=0.15) }}

{% macro is_chronically_absent(absent_col, enrolled_col, threshold=0.10) %}
    case
        when {{ enrolled_col }} = 0 then false
        when ({{ absent_col }} * 1.0 / {{ enrolled_col }}) >= {{ threshold }} then true
        else false
    end
{% endmacro %}
