#SOMEVAR='bar'

## Docker

dc.up:
	docker-compose up -d

dc.build:
	docker-compose up -d --build

dc.recreate:
	docker-compose up -d --no-deps --build $(filter-out $@,$(MAKECMDGOALS))


## PHP

php.connect:
	docker-compose exec php bash

php.connect.root:
	docker-compose exec --user=root php bash


## Nginx

nginx.connect:
	docker-compose exec nginx sh


## Redis

redis.connect:
	docker-compose exec redis sh



## Composer

composer:
	docker-compose exec php composer $(filter-out $@,$(MAKECMDGOALS))

