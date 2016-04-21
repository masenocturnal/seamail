-- Revert insert_tables

BEGIN;

use mysql;
drop database mailtest;

COMMIT;
