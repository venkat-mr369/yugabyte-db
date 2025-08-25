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

Here is a comprehensive list of more than 30 useful **PSQL (PostgreSQL CLI) meta-commands** that can be used while interacting with YugabyteDB's YSQL shell or standard PostgreSQL CLI:

***

## Useful PSQL (CLI) Meta-Commands

| Command        | Description                                       |
|----------------|-------------------------------------------------|
| `\?`           | Show all psql commands and help                  |
| `\q`           | Quit/exit the psql shell                          |
| `\c [dbname]`  | Connect to a new database (or `\connect`)        |
| `\d`           | List tables, views, and sequences                 |
| `\dt`          | List tables                                       |
| `\di`          | List indexes                                      |
| `\ds`          | List sequences                                    |
| `\dv`          | List views                                       |
| `\df`          | List functions                                    |
| `\du`          | List roles/users                                  |
| `\l` or `\list`| List all databases                               |
| `\x`           | Toggle expanded display for query results         |
| `\timing`      | Toggle query timing on/off                         |
| `\set`         | Set or show psql variables                         |
| `\g`           | Execute the current query buffer                   |
| `\p`           | Show the current query buffer                       |
| `\r`           | Reset (clear) the query buffer                      |
| `\ef [func]`   | Edit a function using the default editor           |
| `\copy`        | Perform SQL COPY to/from a file                     |
| `\h [command]` | Show help on SQL commands (e.g., `\h SELECT`)      |
| `\watch [sec]` | Re-execute query every specified seconds            |
| `\o [file]`    | Send query output to a file (or stdout if empty)    |
| `\i [file]`    | Execute commands from a file                         |
| `\! [cmd]`     | Execute a shell command                              |
| `\setenv`      | Set or show environment variables                   |
| `\cd [dir]`    | Change the working directory                         |
| `\encoding`    | Show or set client encoding                           |
| `\a`           | Toggle output between aligned and unaligned format  |
| `\H`           | Toggle HTML output mode                               |
| `\x auto`      | Auto toggle expanded format based on output size     |
| `\ef [function name]` | Open function definition in editor                  |
| `\ddp`         | List default privileges                              |
| `\z`           | Show access privileges on tables (same as `\dp`)    |
| `\dp`          | Show access privileges on tables and columns         |
| `\wait`        | Wait for asynchronous query completion                 |

***


