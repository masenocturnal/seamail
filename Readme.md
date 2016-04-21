
# Creating Passwords 
update virtual_users set password_hash = ENCRYPT('test',CONCAT('$6$', hash_salt )) where id=1;

