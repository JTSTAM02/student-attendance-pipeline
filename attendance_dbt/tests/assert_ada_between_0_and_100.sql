-- This test fails if any school has an ADA outside 0-100%
-- dbt tests pass when the query returns 0 rows
-- dbt tests fail when the query returns any rows

select
    school_id,
    ada_pct
from {{ ref('mart_ada') }}
where ada_pct < 0
   or ada_pct > 100
