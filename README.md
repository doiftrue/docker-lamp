Installation
============

1. Install Docker
2. Clone this repository 
3. Perform following commands
    - `docker-compose up -d`



Nginx
-----

Enter into container:

    docker exec -it CONTAINER_ID sh

    nginx -t           # Test config
    nginx -T           # Test & Dump config
    nginx -s reload    # reload the configuration file
    nginx -s quit      # graceful shutdown
