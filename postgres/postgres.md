
```sql
-- List all materialized views
select schemaname as schema_name,
       matviewname as view_name,
       matviewowner as owner,
       ispopulated as is_populated,
       definition
from pg_matviews
order by schema_name,
         view_name;
```
