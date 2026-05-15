-- macros/absence_flags.sql
-- Generates standardized absence flag columns.
-- excuse_col: column indicating if absence was excused (1=excused, 0=unexcused)
-- If your source doesn't have this yet, pass 'null' and it defaults to 0 (unexcused).

{% macro is_absent_flag(present_col, enrolled_col) %}
    case
        when {{ present_col }} = 0 and {{ enrolled_col }} = 1 then 1
        else 0
    end
{% endmacro %}

{% macro is_truant_flag(present_col, enrolled_col, excused_col='0') %}
    case
        when {{ present_col }} = 0
         and {{ enrolled_col }} = 1
         and coalesce({{ excused_col }}, 0) = 0
        then 1
        else 0
    end
{% endmacro %}
