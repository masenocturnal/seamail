# Intro

Email sucks; It's hard to manage, needs constant managing but we need it.  It's currently the de facto standard of electronic communication between organisations. 

Many organisations and individuals would like to have the privacy, security and control guarantees that come with owning and operating their own mail server. 
The practical reality is that they often aren't in the position to support their own mail setup. Even seasoned admins and developers often can't spare the time to keep the server up to date
and having a single administrator can be a bottleneck. 

The alternative currently is to out source the problem. Delegating the responsibility to 3rd parties such as Google, Microsoft and Protonmail. There needs to be a middle ground.  
So let's make mail as easy as possible to setup and administer. 


## What does this mean ?

Wouldn't it be nice to point any number of domains to a mail server server and be able to accept mail in minutes? Just add your domain name and your users and that's it.
No fighting with SPAM, instant webmail, up to date statistics and the ability so switch on an off users, create aliases etc.. 


 * Multi-domain,
 * Multi-tenant
 * Standards compliant. 

We use the best components to allow you to run your own mailserver without the time and the effort typically devoted to administering your own server. 

 - Postfix 
 - Dovecot 
 - SpamAssassin
 - MailRoom 
 - Round Cube


## How it works

Let's say you have one of our brand spanking new servers provisioned. When someone (Cathy) sends an email to you, what actually happens is Cathy sends an email to her MTA. 
Her MTA then performs a DNS lookup for something called an MX record. This MX record, tells Cathy's MTA where to relay her email. It's just like when you send a letter in real life. You send
your letter to your local postoffice and your postoffice looks up the Post(zip) Code and directs it to the closest general post office. 

Now in this instance we have a post office of our own. This is the MTA or Mail Transfer Agent. We use Postfix for this.  
Postfix accepts email from it's local users on port 587 (often referred to as the submission port). It also accepts mail from other post offices (MTA's) on port 25.
Mail is transferred from one node to another using a protocol called SMTP (Simple Mail Transfer Protocol) 

Just like mail in real life, the rules for accepting mail in these two scenarios is different. 

### Accepting mail from local users

In real life, we affix a stamp to letters to authenticate with our GPO that they are allowed to relay mail. Mail is also only accepted from trusted postoffice boxes. The same is true in the email world.
However, instead of stamp, we provide our username and password (or certificate) as a method of authentication. Once we have authenticated, Postfix knows that it is allowed to relay this email message to 
the destination server.   
 

### Accepting mail from MTA's 

Generally a post office will accept any letter provided it is addressed to a valid address in a post code that it has been designated to acceept mail for. In the electronic form, a similar rule applies. 
Postfix will listen on port 25 for any incoming connections. It will look at any incoming mail. If it is for a domain that it accepts mail for, it will then check that it is for a user that is in that domain. 
So long as it passes both those tests, it will accept the email. 

### SPAM 

You know those catalogs that clog up your mail box and cause your letters to pile up underneath ? Well that's what SPAM is. Unlike real life, we have the ability to scan the email that comes in
to see if it looks like SPAM. If it is, we can mark it so that it can be put in a different pile which we can ignore and recycle every few weeks. 

To do this, postfix will connect locally to a process called SpamAssa ssin on port 2465 (@todo? can't remember what i chose). SpamAssassin will scan the email against a database of traits that
would indicate that the email is SPAM. If it thinks it's spam it marks the headers with a ****SPAM***** tag otherwise it leaves the email untouched.

Once it's done, it connects back to postfix for the email to be queued. 

### Delivery 

Now we are set to deliver our mail. We have a few options here. We use a local delivery agent provded by Dovecot to handle this (LDA). Postfix connects to LDA via a local TCP/IP port. 
This time, it speaks LMTP instead of SMTP. LDA's job is to look up the email address and find the on-disk location for that email. This is called the mailbox. 
Once it's found the mailbox it is responsible for writing that file to disk and ensuring the filesystem has saved it in a specific format. We use the Maildir format.  
Before it does that, we get it to quickly look at the email for the spam tag or to see if it matches any other rules (Sieve Scripts) which would alter where it should go or how it should be written.
The most common example is that anything with a spam tag will go in the Spam folder. 

### Pickup

Now that the mail has been written to disk, we need some way for an external client to check their mail. An external client in this instance is a Mail User Agent (MUA). Mozilla Thunderbird, Outlook, 
K9Mail and Mail.App are all examples of MUAs. The MUA talks IMAP (Internet Message Access Protocol) to our server on port 993. We again use a Dovecot component to provide this functionality. Dovecot IMAP.


### MariaDB ?

Ok so our mail is all delivered? What is MariaDB used for ?

Well at each stage, Postfix, SpamAssassin, Dovecot LDA and Dovecot IMAP are all making decisions based on which domains and users we accept mail for. We don't want to duplicate 
this information and we want to provide an easy way to administer these domaians and accounts. So instead of writing this information to config files, we instruct these services to store and retrieve 
the information they need in a central database. We use MariaDB for this. It's fast, light and concurrent with very low connection overhead. It's fairly easy to replicate and scale, so we think this is a 
good choice for the job.

### what's next?
The above is just a brief intro. Like most things, the devil is in the details and the above is a bit of a simplification. To really understand it, it's worth setting up a development environment 
so you can see exactly how and why this is all glued together the way it is.
  

## Getting Started (Development) 

Initial configuration targets 16.04. 
It is intended to be deployable cross distro and the effort to make this happen is minimal. It just hasn't been done yet. Contributions are welcome. 

### Git

    $ git clone https://github.com/masenocturnal/seamail.git
    $ cd seamail
    $ git submodule update --init --remote --recursive

## Easy Way

    
### Docker 

Doesn't work 100% just yet
  
    $ cd Dockerfiles
    $ ./mk_images (only required on first setup)
    $ ./start_containers
     
### Vagrant (windows)
Also not working 
    
    vagrant up --provider=hyperv

### Vagrant (Linux)

    vagrant up --provider=libvirt


## Hard Way

This works but involves more work.

### Base system
To begin with, install a base 16.04 system.

### Install Database 

Currently only MariaDB is supported in terms of databases however PG support will soon follow. 
We use the excellent [Sqitch](http://www.sqitch.org) for database change management.

#### MariaDB

Follow the instructions on the MariaDB website to add the apt repositories.
[MariaDB Repo Wizard](https://downloads.mariadb.org/mariadb/repositories/#mirror=aarnet_pty_ltd&distro=Ubuntu&distro_release=trusty--ubuntu_trusty&version=5.5)

e.g

    $ sudo apt-get install software-properties-common
    $ sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
    $ sudo add-apt-repository 'deb [arch=amd64,i386] http://mirror.aarnet.edu.au/pub/MariaDB/repo/5.5/ubuntu trusty main'
 
    $ sudo apt-get update
    $ sudo apt-get install mariadb-server
    
    $ mysql -u root -p
    $> CREATE DATABASE mailtest   // currently this is hardcoded so use this name @todo
    $> GRANT SELECT,EXECUTE on mailtest.* to 'postfix'@'localhost' identified by '<random pw here>';
    $> GRANT SELECT,EXECUTE,UPDATE on mailtest.* to 'dovecot'@'localhost' identified by '<different random pw here>';

#### PostgreSQL
    @todo

### Single machine setup
    $ sudo apt-get install \
    postfix \
    postfix-mysql \
    sasl2-bin \ 
    dovecot-common \
    dovecot-mysql \
    dovecot-imapd \
    dovecot-lmtpd \
    dovecot-managesieved \ 
    git-core

- could not find package dovecot-mysql? 
    
- You will be asked about default configurations and ssl certs - say no to these as they will be setup later.        

### Sqitch
Unfortunately the 14.04 sqitch package is broken so cpan or cpanm seem to be the only mechanism of getting a 
working sqitch install. Mysql::Config is required if you wish to use a ~/.my.cnf for authenticationn (recommended for development) 

    $ sudo perl -MCPAN -e 'install App::Sqitch DBD::mysql' 
    $ sudo perl -MCPAN -e 'install MySQL::Config'
    $ echo "[client]
host=localhost
user=root
password=<thisisnotmypassword>" >> ~/.my.cnf

OR

```export SQITCH_PASSWORD=<mypwd>```


### Git


    $ git clone https://github.com/masenocturnal/seamail.git
    $ cd seamail
    $ git submodule update --init --remote --recursive
    
- Could not clone submodule amavis, not enough access rights?    
    
### Deploy Databases

    $ sqitch deploy dev
    
    $ mysql mailtest 

## Database Schema
 @todo 

### Creating Passwords 
update virtual_users set password_hash = ENCRYPT('test',CONCAT('$6$', hash_salt )) where id=1;

