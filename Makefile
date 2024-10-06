-include Makefile-extend.mk

# Handle `$ make` run without target
.DEFAULT_GOAL := help
help: ## Display this help screen
	@grep -h -E '^[a-zA-Z0-9._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


#####################
# Docker
#####################

d.up: ## Start all containers
	docker compose up -d

d.stop: phpmyadmin.stop mailpit.stop ## Stop all containers
	docker compose stop

d.start: ## Start all containers
	docker compose start

d.down: phpmyadmin.stop mailpit.stop ## Stop and remove all containers
	docker compose down --remove-orphans

d.recreate: ## Recreate all containers
	docker compose up --no-deps -d --force-recreate

d.rebuild: ## Rebuild all images and recreate all containers
	docker compose up --no-deps -d --build



#####################
# PHP
#####################

php.connect: ## Connect to php container
	docker compose exec php bash

php.connect.root: ## Connect to php container as root user
	docker compose exec --user=root php bash

php.ini.copy: ## Copy "php.ini" file from php container to local "php" directory
	docker compose cp php:"/usr/local/etc/php/php.ini" "./php/php.ini"



#####################
# Composer
#####################

# $ make composer install
# $ make composer update
# $ make goto.php >>> $ composer update -o
composer: ## Run composer command. Eg: $ make composer install
	docker compose exec php composer $(filter-out $@,$(MAKECMDGOALS))



#####################
# Nginx
#####################

nginx.connect: ## Connect to nginx container
	docker compose exec nginx sh



#####################
# Redis
#####################

redis.connect: ## Connect to redis container
	docker compose exec redis sh



#####################
# mysql
#####################

mysql.connect: ## Connect to mysql container
	docker compose exec mysql sh



#####################
# PhpMyAdmin
#####################

pma: phpmyadmin ## Alilas of "phpmyadmin" command
phpmyadmin: ## Runs phpmyadmin container
	docker run --rm -d --name LAMP_phpmyadmin --network lamp-net -e PMA_HOST=mysql -e PMA_USER=root -e PMA_PASSWORD=root -p 9200:80 phpmyadmin:latest
	@echo "Goto: http://localhost:9200"

# Stops phpmyadmin container (it will be removed automatically because of --rm flag)
# NOTE: first '-' prefix tells make to continue executing the subsequent commands even if the docker stop command fails.
phpmyadmin.stop: ## Stops & Remove phpmyadmin container
	-docker stop LAMP_phpmyadmin



#####################
# eMail testing tool
#####################

# https://hub.docker.com/r/axllent/mailpit
mailpit: ## Runs mailpit container
	docker run --rm -d --name=LAMP_mailpit --network lamp-net -p 8025:8025 -v ./db/mailpit-data:/data -e MP_DATABASE=/data/mailpit.db axllent/mailpit
	@echo "Goto: http://localhost:8025"

# Stops mailpit container (it will be removed automatically because of --rm flag)
mailpit.stop: ## Stops & Remove mailpit container
	-docker stop LAMP_mailpit



#####################
# Certs
#####################

# $ make create-cert example.loc
create-cert: ## Create SSL certificate. Eg: $ make create-cert example.loc
	bash certs/create-cert.sh $(filter-out $@,$(MAKECMDGOALS))



#####################
# Logs
#####################

log.nginx: ## see access log
	docker compose logs -f nginx

