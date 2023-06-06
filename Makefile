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
	docker-compose build --force-rm && docker-compose up -d

dc.recreate:
	make dc.down && docker-compose build --force-rm --pull && docker-compose up -d



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



#### mysql ####

goto.mysql:
	docker-compose exec mysql sh



#### certs ####

# $ make generate.cert example.loc
create-cert:
	bash certs/create-cert.sh $(filter-out $@,$(MAKECMDGOALS))



