#!/bin/bash
MSG="Hello World 1"
echo  $MSG | mail -s "Test Email" "Test User <test.user@example.com>"
