-- Deploy mailserver:setup_postfix_user to mysql

BEGIN;

use mailtest;

GRANT select on mailtest.* to 'postfix'@'%' identified by 'test';

COMMIT;
