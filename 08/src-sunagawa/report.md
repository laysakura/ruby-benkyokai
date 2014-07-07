## SQL
```sql
 select * from user limit 10

```

### Benchmark
| user       | system     | total      | real         |
| ----------:| ----------:| ----------:| ------------:|
| 0.01000000 | 0.00000000 | 0.01000000 | (0.00031465) |

### EXPLAIN
|id           |1      |
|-------------|:------|
|select_type  |SIMPLE |
|table        |user   |
|type         |ALL    |
|possible_keys|       |
|key          |       |
|key_len      |       |
|ref          |       |
|rows         |1000224|
|Extra        |       |
## SQL
```sql
 select recipe.title from user join recipe on recipe.user_id = user.id where user.id < 100

```

### Benchmark
| user       | system     | total      | real         |
| ----------:| ----------:| ----------:| ------------:|
| 0.00000000 | 0.00000000 | 0.00000000 | (0.00017828) |

### EXPLAIN
|id           |1          |1                       |
|-------------|:----------|:-----------------------|
|select_type  |SIMPLE     |SIMPLE                  |
|table        |recipe     |user                    |
|type         |range      |eq_ref                  |
|possible_keys|user_id_idx|PRIMARY                 |
|key          |user_id_idx|PRIMARY                 |
|key_len      |4          |4                       |
|ref          |           |rakumeshi.recipe.user_id|
|rows         |19         |1                       |
|Extra        |Using where|Using index             |
