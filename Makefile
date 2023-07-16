#SOMEVAR='bar'

#### Docker ####

dc.up:
	docker-compose up -d

dc.stop: phpmyadmin.stop
	docker-compose stop

dc.start:
	docker-compose start

dc.down: phpmyadmin.stop
	docker-compose down --remove-orphans

dc.build:
	docker-compose build --force-rm && docker-compose up -d

dc.recreate:
	make dc.down && docker-compose build --force-rm --pull && docker-compose up -d



#### PHP ####

goto.php:
	docker-compose exec php bash

goto.php.root:
	docker-compose exec --user=root php bash

php.copy.ini:
	docker compose cp php:"/usr/local/etc/php/php.ini" "./php.ini"



#### Composer ####

# $ make composer install
# $ make composer update
# $ make goto.php >>> $ composer update -o
composer:
	docker-compose exec php composer $(filter-out $@,$(MAKECMDGOALS))



#### Nginx ####

goto.nginx:
	docker-compose exec nginx sh



#### Redis ####

goto.redis:
	docker-compose exec redis sh



#### mysql ####

goto.mysql:
	docker-compose exec mysql sh



#### PhpMyAdmin ####

# Runs phpmyadmin container
phpmyadmin:
	docker run --rm -d --name LAMP_phpmyadmin --network lamp-net -e PMA_HOST=mysql -e PMA_USER=root -e PMA_PASSWORD=root -p 9200:80 phpmyadmin:latest
	@echo "Goto: http://localhost:9200"

# Stops phpmyadmin container (it will be removed automatically because of --rm flag)
# NOTE: first '-' prefix tells make to continue executing the subsequent commands even if the docker stop command fails.
phpmyadmin.stop:
	-docker stop LAMP_phpmyadmin



#### certs ####

# $ make create-cert example.loc
create-cert:
	bash certs/create-cert.sh $(filter-out $@,$(MAKECMDGOALS))



