# How to use these files

Each `sql` script in this folder needs to be executed using the appropriate database.  
Due to foreign key constraints, a proper order must be followed.  
`_MASTER_.sql` has the proper order, and can be executed like so:  

```sql
use baseball;
source /path/to/_MASTER_.sql;
```

Which will then execute each script in order.  
Then, verify that each statement was successful.  