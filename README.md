Installation
============

1. Install Docker
2. Clone this repository 
3. Perform following commands
    - `docker-compose up -d`
4. Add `127.0.0.1  mysite-example.loc` into the `/etc/hosts` file.


Add new site
------------

To add your own site use examples from `nginx/sites-enabled-examples`.
1. Copy `example.conf` or `example-ssl.conf` file to the `nginx/sites-enabled` folder.
2. Rename the copied file as you widh and change it's content (change domain name to yours for example `mysite.loc`).
3. This new file copied will be automatically added to the nginx config.
4. Add `127.0.0.1  mysite.loc` into your OS `hosts` file. For linux it's a `/etc/hosts` file.


PHP
---

### Redis

For redis work correctly add into the `wp-config.php` file:

   define( 'WP_REDIS_HOST', 'redis' );



Nginx
-----

Enter into container:

    docker exec -it CONTAINER_ID_OR_NAME sh

    nginx -t           # Test config
    nginx -T           # Test & Dump config
    nginx -s reload    # reload the configuration file
    nginx -s quit      # graceful shutdown
