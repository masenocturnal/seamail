# Introduction

This is an attempt to set up a full featured, deployable communications server, primarily starting with Email. 


## What does this mean ?

 @todo add general description
Multi-domain, multi-tennant, standards compliant. 


Currently this is comprised of: 

 - Postfix
 - Dovecot
 - Amavis
 - MailRoom 
 - Round Cube

## Getting Started 

Initial configuration targets Ubuntu 14.04 however with 16.04 just being released we will upgrade shortly. 
It is intended to be deployable cross distro and the effort to make this happen is minimal. It just hasn't been done yet. Contributions are welcome. 

### Base system
To begin with, install a base 14.04 system.

### Install Database 

#### MariaDB

Follow the instructions on the MariaDB website to add the apt repositories.
[MariaDB Repo Wizard](https://downloads.mariadb.org/mariadb/repositories/#mirror=aarnet_pty_ltd&distro=Ubuntu&distro_release=trusty--ubuntu_trusty&version=5.5)

e.g

    sudo apt-get install software-properties-common
    sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
    sudo add-apt-repository 'deb [arch=amd64,i386] http://mirror.aarnet.edu.au/pub/MariaDB/repo/5.5/ubuntu trusty main'

    sudo apt-get update
    sudo apt-get install mariadb-server

#### PostgreSQL
    @todo

### Single machine setup
    apt-get install \
    postfix \
    postfix-mysql \
    sasl2-bin \ 
    ovecot-core \
    dovecot-mysql \
    dovecot-imapd \
    dovecot-lmtpd \
    dovecot-managesieved

### Sqitch
    sudo cpan App::Sqitch DBD::mysql Mysql::Config

### Docker
 @ todo
### Vagrant 
 @ todo


### Creating Passwords 
update virtual_users set password_hash = ENCRYPT('test',CONCAT('$6$', hash_salt )) where id=1;

