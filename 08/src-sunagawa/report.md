## SQL
```sql
 select * from user limit 10

```

### Benchmark
| user       | system     | total      | real         |
| --------- :| --------- :| --------- :| ----------- :|
| 0.00000000 | 0.00000000 | 0.00000000 | (0.00018759) |

### EXPLAIN
| column_name   | value   |
| -------------:|:------- |
| id            | 1       |
| select_type   | SIMPLE  |
| table         | user    |
| type          | ALL     |
| possible_keys |         |
| key           |         |
| key_len       |         |
| ref           |         |
| rows          | 1000224 |
| Extra         |         |

## SQL
```sql
 select recipe.title from user join recipe on recipe.user_id = user.id where user.id < 100

```

### Benchmark
| user       | system     | total      | real         |
| --------- :| --------- :| --------- :| ----------- :|
| 0.00000000 | 0.00000000 | 0.00000000 | (0.00022262) |

### EXPLAIN
| column_name   | value       |
| -------------:|:----------- |
| id            | 1           |
| select_type   | SIMPLE      |
| table         | recipe      |
| type          | range       |
| possible_keys | user_id_idx |
| key           | user_id_idx |
| key_len       | 4           |
| ref           |             |
| rows          | 19          |
| Extra         | Using where |

| column_name   | value                    |
| -------------:|:------------------------ |
| id            | 1                        |
| select_type   | SIMPLE                   |
| table         | user                     |
| type          | eq_ref                   |
| possible_keys | PRIMARY                  |
| key           | PRIMARY                  |
| key_len       | 4                        |
| ref           | rakumeshi.recipe.user_id |
| rows          | 1                        |
| Extra         | Using index              |

