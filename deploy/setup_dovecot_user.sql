-- Deploy mailserver:setup_dovecot_user to mysql

BEGIN;

use mailtest;

GRANT select on mailtest.* to 'dovecot'@'%' identified by 'test';


COMMIT;
