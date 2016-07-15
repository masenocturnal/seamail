-- Deploy mailserver:setup_dovecot_user to mysql

BEGIN;

use mailtest;

GRANT select on mailtest.* to 'dovecot'@'%' identified by 'test';
GRANT select,delete,insert,update on mailtest.quota to 'dovecot'@'%';
GRANT select,update,delete,insert on mailtest.expires to 'dovecot'@'%';


COMMIT;
