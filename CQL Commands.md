***to connect to yugabyte CSQL**

./ycqlsh 10.166.0.2 9042 -u cassandra

#### Sample Table and Data Inserts in CQL

```cql
-- Create keyspace
CREATE KEYSPACE employees_keyspace WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'};

-- Use the keyspace
USE employees_keyspace;

-- Create table
CREATE TABLE employees (
    id int PRIMARY KEY,
    name text,
    age int,
    city text
);

-- Insert 50 records with Indian names (examples)
INSERT INTO employees (id, name, age, city) VALUES (1, 'Arnav', 46, 'Delhi');
INSERT INTO employees (id, name, age, city) VALUES (2, 'Saanvi', 47, 'Kolkata');
INSERT INTO employees (id, name, age, city) VALUES (3, 'Rohan', 22, 'Mumbai');
-- ... continue till 50 records
```

***

# Useful Cassandra CQL Meta-Commands with Examples

| Command                       | Description                                | Example                                                       |
|-------------------------------|--------------------------------------------|---------------------------------------------------------------|
| `DESCRIBE KEYSPACES;`          | List all keyspaces                         | `DESCRIBE KEYSPACES;`                                          |
| `DESCRIBE KEYSPACE keyspacename;` | Show details of a keyspace               | `DESCRIBE KEYSPACE employees_keyspace;`                       |
| `CREATE KEYSPACE`              | Create a new keyspace                      | See above `CREATE KEYSPACE` example                            |
| `DROP KEYSPACE keyspacename;` | Drop a keyspace                            | `DROP KEYSPACE employees_keyspace;`                           |
| `USE keyspacename;`            | Switch keyspace                           | `USE employees_keyspace;`                                      |
| `DESCRIBE TABLES;`             | List tables in the current keyspace       | `DESCRIBE TABLES;`                                             |
| `DESCRIBE TABLE tablename;`    | Describe table structure                   | `DESCRIBE TABLE employees;`                                    |
| `CREATE TABLE tablename;`      | Create a new table                         | See above `CREATE TABLE employees` example                     |
| `DROP TABLE tablename;`        | Drop a table                              | `DROP TABLE employees;`                                        |
| `SELECT * FROM tablename;`     | Select all records                        | `SELECT * FROM employees;`                                     |
| `SELECT col1, col2 FROM tablename WHERE condition;` | Select with conditions                   | `SELECT name, city FROM employees WHERE id=5;`                 |
| `INSERT INTO tablename (...) VALUES (...);` | Insert data                            | See above insert examples                                      |
| `UPDATE tablename SET col=val WHERE pk=val;` | Update record                          | `UPDATE employees SET age=30 WHERE id=10;`                     |
| `DELETE FROM tablename WHERE pk=val;` | Delete record                           | `DELETE FROM employees WHERE id=12;`                           |
| `TRUNCATE tablename;`          | Delete all records from a table           | `TRUNCATE employees;`                                          |
| `ALTER TABLE tablename ADD col TYPE;` | Add column to table                     | `ALTER TABLE employees ADD email text;`                        |
| `CREATE INDEX indexname ON tablename(col);` | Create secondary index                   | `CREATE INDEX ON employees (city);`                            |
| `DROP INDEX indexname;`        | Drop index                               | `DROP INDEX employees_city_idx;`                               |
| `BATCH` statement              | Perform batch writes                      | `BEGIN BATCH INSERT INTO ... APPLY BATCH;`                    |
| `SELECT COUNT(*) FROM tablename;` | Count rows (warning: inefficient)        | `SELECT COUNT(*) FROM employees;`                              |
| `CONSISTENCY` level            | Set consistency of queries                 | `CONSISTENCY QUORUM;`                                          |
| `DESCRIBE USER;` or `LIST USERS;` | List users                              | `LIST USERS;`                                                 |
| `CREATE ROLE rolename;`        | Create a role                            | `CREATE ROLE manager WITH PASSWORD = 'pass' AND LOGIN = true;`|
| `GRANT permission ON resource TO role;` | Grant permissions                      | `GRANT SELECT ON employees TO manager;`                       |
| `REVOKE permission ON resource FROM role;` | Revoke permissions                    | `REVOKE SELECT ON employees FROM manager;`                    |
| `TRACING ON;`                  | Enable query tracing                      | `TRACING ON;`                                                 |
| `TRACING OFF;`                 | Disable query tracing                     | `TRACING OFF;`                                                |
| `EXPLAIN`                     | Explain query plan (limited support)      | `EXPLAIN SELECT * FROM employees;`                            |
| `CONSISTENCY` clause           | Query consistency level                    | `SELECT * FROM employees WHERE id=1 CONSISTENCY ONE;`        |
| `COPY tablename (cols) TO 'file.csv';` | Export data to CSV                      | `COPY employees (id, name) TO 'employees.csv';`               |
| `COPY tablename FROM 'file.csv';` | Import data from CSV                      | `COPY employees FROM 'employees.csv';`                         |
| `LIST TABLES;`                 | List tables in keyspace                    | `LIST TABLES;`                                               |

***

# Notes on Cassandra Procedures, Views, Functions

- Cassandra does not support **stored procedures** or **views** as in relational databases.
- Complex logic is typically handled in application code or via lightweight transactions and batch statements.
- Custom server-side functions are not available; transformations happen client-side or with materialized views where supported.

***

