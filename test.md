Here is an extended list of **20+ useful psql (PostgreSQL CLI) meta-commands**, including the ones you provided, which are all fully usable in YugabyteDB’s YSQL interactive shell:

***

## Extended Useful PSQL Meta-Commands

| Command      | Description                              |
|--------------|----------------------------------------|
| `\dt`        | List tables in the current database    |
| `\di`        | List indexes                           |
| `\df`        | List functions                        |
| `\du`        | List roles/users                     |
| `\x`         | Toggle expanded display (wide output)  |
| `\set`       | Set or unset psql variables             |
| `\timing`    | Toggle query execution timing on/off    |
| `\q`         | Quit psql shell                       |
| `\d`         | Describe objects (tables, views, sequences) |
| `\d+`        | Detailed description including table size and description |
| `\l` or `\list` | List all databases               |
| `\c [dbname]`| Connect to a different database       |
| `\dp`        | Show access privileges (permissions)  |
| `\du+`       | List roles/users with extra info       |
| `\df+`       | Show functions with additional details |
| `\dv`        | List views                            |
| `\dn`        | List schemas                         |
| `\db`        | List tablespaces                    |
| `\e`         | Open default editor to edit query buffer |
| `\watch [seconds]` | Repeat the query every specified seconds |
| `\encoding`  | Show or set client encoding           |
| `\password`  | Change user password                   |
| `\setenv`   | Set environment variables for psql     |
| `\g` or `;` | Execute the current query buffer       |
| `\o [filename]` | Send query output to a file or pipe  |
| `\copy [table]` | Copy data to/from file (client-side)   |
| `\ev [name]` | Edit a saved query or function        |
| `\ef [name]` | Edit function definition               |
| `\watch` (with or without argument) | Re-execute the last query repeatedly   |
| `\prompt [text]` | Prompt user for input and store in variable |
| `\set QUIET` | Suppress variable substitution display |

***

These meta-commands help manage databases, explore objects, script automation, format output, and edit queries efficiently from the psql command line in YugabyteDB.
