Installation
============

1. Install Docker
2. Clone this repository 
3. Perform following commands:
    - `docker-compose up -d`
    - `cp .env.sample .env`
4. Add `127.0.0.1  example.loc` into the `/etc/hosts` system file. On Windows this file located in: `C:\Windows\System32\Drivers\etc\hosts`.
5. Done: Go to `http://example.loc` in your browser, and `./sites/example.loc/www/index.php` file will handle this request.


How to add a new site
---------------------

### Option 1:
1. Create site folder. Assume you domain will be: `mysite.loc`, so create file: `./sites/mysite.loc/www/index.php`.
2. Add `mysite.loc` to system `hosts` file: `127.0.0.1  mysite.loc`.
3. Done: go to `http://mysite.loc`.

### Options 2:
This variant allowes you to configure nginx, site file structure, and all other things as you need.
Here you need to use one of examples from `nginx/sites-enabled-examples/`.
1. Copy `example.conf` or `example-ssl.conf` file to the `nginx/sites-enabled` folder.
2. Rename the copied file as you like and change its content (change the domain name, for example `mysite.loc`).
3. Restart docker: `$ make dc.down && make dc.up`. The copied file will be automatically added to the nginx config inside container.
4. Add `127.0.0.1  mysite.loc` into your OS `hosts` file. For linux it's a `/etc/hosts`.
5. Done: go to `http://mysite.loc`.


PHP
---

Go into the container:

    make goto.php


### Redis

For redis work correctly add into the `wp-config.php` file:

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
