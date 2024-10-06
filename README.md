Installation
============

1. Install Docker
2. Clone this repository 
3. Perform following commands:
   ```
   touch php/config.php.ini
   touch php/.bash_history
   cp .env.sample .env
   make create-cert example.loc
   make d.up
   ```
4. Add `127.0.0.1  example.loc` into the `/etc/hosts` system file. 
   On Windows this file located in: `C:\Windows\System32\Drivers\etc\hosts`.
5. Done!
6. Go to `http://example.loc` in your browser, and `./sites/example.loc/www/index.php` file will handle this request.


How to add a new site
---------------------
In instruction bellow we assume you new site domain is: `mysite.loc`.

### Option 1:
1. Add `mysite.loc` to system `hosts` file: `127.0.0.1  mysite.loc`.
2. Create site folder and main file in it: `./sites/mysite.loc/www/index.php`.
3. Done! Goto `http://mysite.loc`.

### Option 2 (configure all):
This option allowes you to configure all things: nginx, site file structure etc.
Here you need to use one of examples from `nginx/sites-enabled-examples/`:

1. Add `mysite.loc` to system `hosts` file: `127.0.0.1  mysite.loc`.
2. Copy `example.conf` file to the `nginx/sites-enabled` folder.
3. Rename `example.conf` to `mysite.loc.conf` (it's not necessary, but it's more convenient for you.).
4. Restart docker containers: `$ make d.down && make d.up` to add new file to the nginx config inside container.
5. Done! Goto `http://mysite.loc`.

### Option 3 (https, SSL)
To crate SSL based site your need to use instructions from "Option 2", but use `example-ssl.conf` file instead.
And after all, you need to crate self-signed sertificate for your new site. Run command:
```sh
make create-cert mysite.loc
```
And if you add site for the first time, you need add root certificate (ROOT CA) to your system and browser. See instruction [from here](certs/README.md).



PHP
---
Go into the container:

    make goto.php


xDebug
------
- See all parameters: https://xdebug.org/docs/all_settings
- See: [Upgrading from Xdebug 2 to 3](https://xdebug.org/docs/upgrade_guide)
- See: https://xdebug.org/docs/all_settings#xdebug.start_with_request

To enable xdebug just add config into `php/config.php.ini` file:
```ini
[xdebug]
xdebug.mode = debug
xdebug.start_with_request = default
xdebug.client_host = host.docker.internal
xdebug.client_port = 9003
xdebug.idekey = PHPSTORM
```

To view current values run:
```shell
php -i | grep xdebug
```

Or call php function:
```php
xdebug_info(); exit;
```

To trigger xdebug under WP-CLI use:
```shell
XDEBUG_TRIGGER=1 wp plugin list
```

### xDebug profiling

config.php.ini:
```
xdebug.mode = profile
xdebug.output_dir = /var/app/_tmp_docker_lamp_xdebug_profiles
xdebug.profiler_output_name = cachegrind.%R.%u
;xdebug.trigger_value = ""
```

Viewer programm KCacheGrind. Install for ubuntu:
```shell
sudo apt install kcachegrind
sudo apt install graphviz
```
Check that graphviz installed correctly
```
dot -V
```




Redis
-----
To Redis work correctly you need use "redis" host for redis. 
For example, if you use the WP plugin [Redis Object Cache](https://wordpress.org/plugins/redis-cache/) you need to add the following constant into the `wp-config.php` file:

   define( 'WP_REDIS_HOST', 'redis' );


DB
--
To create your site database, you need to go to phpmyadmin and create datebase:

    $ make phpmyadmin

Goto: http://localhost:9200

OR you can do it using mysql console, by going into the mysql container:

    $ make goto.mysql
    # mysql -uroot -proot
    mysql> SHOW DATABASES;
    mysql> CREATE DATABASE test_database;


Nginx
-----
Go into the container:

    make goto.nginx
    // OR
    docker exec -it nginx sh

Use one of command:

    nginx -t           # Test config
    nginx -T           # Test & Dump config
    nginx -s reload    # reload the configuration file
    nginx -s quit      # graceful shutdown

NOTE: fastcgi_params see inside container `/etc/nginx/fastcgi_params`.


Mail testing
------------
To test mailing on site the mailpit is used. As it neede by demand it wasn't added into the main docker-compose file. So You need to run it (its container) separatelly using the following make command:

	$ make mailpit

Then goto <http://localhost:8025> 

**Additional info:**

> "Mailpit" is a lightweight, self-hosted email testing tool that simulates an SMTP server and provides a web interface for viewing and testing email deliveries.

> "msmtp" is a lightweight SMTP client used to send emails from the command line or scripts. It acts as an SMTP relay, forwarding emails to a specified SMTP server. It's often used in Unix-based systems as a simpler alternative to more complex mail transfer agents (MTAs) like sendmail or postfix.

PHP container is configured to use "msmtp" client to send emails. So, all emails sent from php will be catched by "mailpit" by default. For this porpouse the "msmtp" and "msmtp-mta" packages are added into php image (Dokerfile). 

> The "msmtp-mta" a drop-in replacement for traditional Mail Transfer Agents (MTAs) like "sendmail" or "postfix". This allows programs that expect a sendmail binary to send emails using "msmtp" without changing the configuration. For example PHP's mail() function.

The "msmtp" is configured to use "mailpit" as SMTP server.

You can change config of "msmtp" in the following file `./php/msmtprc.ini`. After any changes you need to recreate the php container: run `$ make d.recreate`.
