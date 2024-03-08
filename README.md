Installation
============

1. Install Docker
2. Clone this repository 
3. Perform following commands:
    - `make create-cert example.loc`
    - `make dc.up`
    - `cp .env.sample .env`
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
4. Restart docker containers: `$ make dc.down && make dc.up` to add new file to the nginx config inside container.
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
