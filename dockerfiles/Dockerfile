FROM ubuntu:16.04
MAINTAINER Andrew Mason <andrew@nocturnal.net.au>
#RUN useradd -b /var/spool/mail vmail
EXPOSE 25
EXPOSE 465
EXPOSE 993
## we use apt-get b/c apt doesn't have a stable CLI interface yet
RUN apt-get update && apt-get install -y postfix postfix-mysql postfix-pcre 
