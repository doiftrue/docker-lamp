#SOMEVAR='bar'

#### Docker ####

dc.up:
	docker-compose up -d

dc.stop:
	docker-compose stop

dc.start:
	docker-compose start

dc.down:
	docker-compose down --remove-orphans

dc.build:
	docker-compose up -d --build

dc.recreate:
	docker-compose up -d --no-deps --build $(filter-out $@,$(MAKECMDGOALS))



#### PHP ####

goto.php:
	docker-compose exec php bash

goto.php.root:
	docker-compose exec --user=root php bash



#### Composer ####

composer:
	docker-compose exec php composer $(filter-out $@,$(MAKECMDGOALS))



#### Nginx ####

goto.nginx:
	docker-compose exec nginx sh



#### Redis ####

goto.redis:
	docker-compose exec redis sh



